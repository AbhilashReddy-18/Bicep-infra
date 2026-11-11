@allowed([
  'nimbusvm'
  'orders'
  'payments'
])
param projectName string

@allowed([
  'dev'
  'uat'
  'prod'
])
param env string

@description('The location of the KV resource')
param location string

param enableSoftDelete bool
param enablePurgeProtection bool
param enableRBACAuthorization bool

@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string

// param sku object

//param tags object

var tags = {
  env: env
  Location: location
  projectName: projectName
}

var KeyVaultName = '${projectName}${env}-kv'

module keyVaultModule 'SharedModules/keyVault.bicep' = {
  name: 'keyVaultModule'
  params: {
    KeyVaultName: KeyVaultName
    location: location
    enableSoftDelete: enableSoftDelete
    enablePurgeProtection: enablePurgeProtection
    enableRBACAuthorization: enableRBACAuthorization
    publicNetworkAccess: publicNetworkAccess
   // sku: sku
    tags: tags
  }
}

//Stoage Account Module

@minLength(3)
@maxLength(24)
@description('Storage account name must be lowercase and globally unique')
param storageAccountName string

//@description('The SKU name for the storage account.')
@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_ZRS'
])
param skuName string   

module storageModule 'SharedModules/storage.bicep' = {
  name: 'storageModule'
  params: {
    storageAccountName: storageAccountName
    location: location
    skuName: skuName
    tags: tags
  }
}


//App Service Module

param WebAppName string

param appservicePlanName string

param appServiceLocation string

param skuplan object

module appServiceModule 'SharedModules/App_service.bicep' = {
  name: 'appServiceModule'
  params: {
    WebAppName: WebAppName
    appServiceLocation: appServiceLocation
    skuplan: skuplan
    appservicePlanName: appservicePlanName
    tags: tags
  }
}

//webapp module


output keyVaultName string = KeyVaultName

output storageAccountName string = storageAccountName

output webAppName string = WebAppName

output appServicePlanName string = appservicePlanName
