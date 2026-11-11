
param WebAppName string

@description('The location of the App service and web app.')
param appServiceLocation string

@description('The SKU name for the App service.')
param skuplan object

param appservicePlanName string




param tags object

resource appServicePlan 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: appservicePlanName
  location: appServiceLocation
  sku: skuplan

}

resource webApp 'Microsoft.Web/sites@2021-02-01' = {
  name: WebAppName
  location: appServiceLocation
  properties: {
    serverFarmId: appServicePlan.id
  }
  tags: tags
}
