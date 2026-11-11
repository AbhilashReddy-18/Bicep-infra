
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
  kind: 'linux'

   properties: {
    reserved: true
  }

}

resource webApp 'Microsoft.Web/sites@2021-02-01' = {
  name: WebAppName
  location: appServiceLocation
  kind: 'app,linux'
  properties: {
    serverFarmId: appServicePlan.id

    siteConfig: {
      linuxFxVersion: 'PYTHON|3.13'
    }

  }
  tags: tags
}
