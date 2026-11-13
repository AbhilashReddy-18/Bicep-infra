param storageAccountName string 


@description('The location of the storage account.')
param location string = 'East US'

@description('The SKU name for the storage account.')
param skuName string = 'Standard_LRS'



param tags object 


//var resourceGroupId = resourceGroup().id




resource storageAccount 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: skuName
  }
  kind: 'StorageV2'
  tags: tags
  properties: {
    accessTier: 'Hot'
  }
}
