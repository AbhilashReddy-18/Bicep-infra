
param WebAppName string = 'nimbus1app'

@description('The location of the storage account.')
param location string = 'West US'

@description('The SKU name for the storage account.')
param skuName string = 'F1'

@allowed([
    'dev'
    'uat'
    'prod'
])
param environment string = 'dev'

var tags = {
env: environment
Location: location
}

resource appServicePlan 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: '${WebAppName}${environment}'
  location: location
  sku: {
    name: skuName
  }

}

resource webApp 'Microsoft.Web/sites@2021-02-01' = {
  name: '${WebAppName}Web${environment}'
  location: location
  properties: {
    serverFarmId: appServicePlan.id
  }
  tags: tags
}
