
param WebAppName string

@description('The location of the storage account.')
param location string

@description('The SKU name for the storage account.')
param skuplan object

param appservicePlanName string




param tags object

resource appServicePlan 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: appservicePlanName
  location: location
  sku: skuplan

}

resource webApp 'Microsoft.Web/sites@2021-02-01' = {
  name: WebAppName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
  }
  tags: tags
}
