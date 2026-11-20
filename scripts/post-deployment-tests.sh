#!/bin/bash

set -e

ENVIRONMENT=$1
RESOURCE_GROUP=$2

mkdir -p Artifact

PROJECT_NAME="nimbusvm"

KEYVAULT_NAME="${PROJECT_NAME}${ENVIRONMENT}-kv"
STORAGE_ACCOUNT_NAME="${PROJECT_NAME}${ENVIRONMENT}storage"
APP_SERVICE_NAME="${PROJECT_NAME}${ENVIRONMENT}webappp"

RESULT_FILE="Artifact/test-results.txt"

OVERALL_STATUS="PASS"

echo "Post Deployment Test Results" > "$RESULT_FILE"
echo "============================" >> "$RESULT_FILE"
echo "" >> "$RESULT_FILE"

echo "Environment    : $ENVIRONMENT" >> "$RESULT_FILE"
echo "Resource Group : $RESOURCE_GROUP" >> "$RESULT_FILE"
echo "Execution Time : $(date -u)" >> "$RESULT_FILE"
echo "" >> "$RESULT_FILE"

pass() {
    echo "$1 : PASS" >> "$RESULT_FILE"
}

fail() {
    echo "$1 : FAIL" >> "$RESULT_FILE"
    OVERALL_STATUS="FAIL"
}

echo "Starting post-deployment validation..."

#
# Key Vault Validation
#

if az keyvault show \
    --name "$KEYVAULT_NAME" \
    --resource-group "$RESOURCE_GROUP" \
    >/dev/null 2>&1; then

    pass "Key Vault Exists"
else
    fail "Key Vault Exists"
fi

KV_ENDPOINT=$(az keyvault show \
    --name "$KEYVAULT_NAME" \
    --resource-group "$RESOURCE_GROUP" \
    --query properties.vaultUri \
    -o tsv)

if curl -s --head --connect-timeout 10 "$KV_ENDPOINT" >/dev/null 2>&1; then
    pass "Key Vault Endpoint Reachable"
else
    fail "Key Vault Endpoint Reachable"
fi

#
# Storage Account Validation
#

if az storage account show \
    --name "$STORAGE_ACCOUNT_NAME" \
    --resource-group "$RESOURCE_GROUP" \
    >/dev/null 2>&1; then

    pass "Storage Account Exists"
else
    fail "Storage Account Exists"
fi

STORAGE_ENDPOINT=$(az storage account show \
    --name "$STORAGE_ACCOUNT_NAME" \
    --resource-group "$RESOURCE_GROUP" \
    --query primaryEndpoints.blob \
    -o tsv)

if curl -s --head --connect-timeout 10 "$STORAGE_ENDPOINT" >/dev/null 2>&1; then
    pass "Storage Endpoint Reachable"
else
    fail "Storage Endpoint Reachable"
fi

#
# App Service Validation
#

if az webapp show \
    --name "$APP_SERVICE_NAME" \
    --resource-group "$RESOURCE_GROUP" \
    >/dev/null 2>&1; then

    pass "App Service Exists"
else
    fail "App Service Exists"
fi

APP_URL="https://${APP_SERVICE_NAME}.azurewebsites.net"

APP_STATUS=$(curl -s \
    -o /dev/null \
    -w "%{http_code}" \
    "$APP_URL")

if [[ "$APP_STATUS" == "200" || "$APP_STATUS" == "301" || "$APP_STATUS" == "302" ]]; then
    pass "App Service Reachable (HTTP $APP_STATUS)"
else
    fail "App Service Reachable (HTTP $APP_STATUS)"
fi

#
# Optional Health Endpoint Test
#

HEALTH_STATUS=$(curl -s \
    -o /dev/null \
    -w "%{http_code}" \
    "$APP_URL/health" || true)

if [[ "$HEALTH_STATUS" == "200" ]]; then
    pass "Health Endpoint Validation"
else
    echo "Health Endpoint Validation : SKIPPED / NOT CONFIGURED" >> "$RESULT_FILE"
fi

#
# Summary
#

echo "" >> "$RESULT_FILE"
echo "Overall Status : $OVERALL_STATUS" >> "$RESULT_FILE"

cat "$RESULT_FILE"

if [ "$OVERALL_STATUS" = "FAIL" ]; then
    exit 1
fi