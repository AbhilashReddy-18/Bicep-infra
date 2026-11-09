#!/bin/bash

ENVIRONMENT=$1
RESOURCE_GROUP=$2

mkdir -p Artifact

ENVIRONMENT=$1

PROJECT_NAME="nimbusvm"

KEYVAULT_NAME="${PROJECT_NAME}${ENVIRONMENT}-kv"
STORAGE_ACCOUNT_NAME="${PROJECT_NAME}${ENVIRONMENT}storage"

echo "$KEYVAULT_NAME"
echo "$STORAGE_ACCOUNT_NAME"

echo "Post Deployment Test Results" > Artifact/test-results.txt
echo "============================" >> Artifact/test-results.txt
echo "" >> Artifact/test-results.txt

echo "Environment : $ENVIRONMENT" >> Artifact/test-results.txt
echo "Resource Group : $RESOURCE_GROUP" >> Artifact/test-results.txt
echo "" >> Artifact/test-results.txt

echo "Validating Key Vault..." >> Artifact/test-results.txt

az keyvault show \
  --name "$KEYVAULT_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  > /dev/null

if [ $? -eq 0 ]; then
  echo "Key Vault Validation : PASS" >> Artifact/test-results.txt
else
  echo "Key Vault Validation : FAIL" >> Artifact/test-results.txt
  exit 1
fi

echo "Validating Storage Account..." >> Artifact/test-results.txt

az storage account show \
  --name "$STORAGE_ACCOUNT_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  > /dev/null

if [ $? -eq 0 ]; then
  echo "Storage Account Validation : PASS" >> Artifact/test-results.txt
else
  echo "Storage Account Validation : FAIL" >> Artifact/test-results.txt
  exit 1
fi

echo "" >> Artifact/test-results.txt
echo "Overall Status : PASS" >> Artifact/test-results.txt
echo "Execution Time : $(date -u)" >> Artifact/test-results.txt