




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

  //param sku object

  param tags object 

  param KeyVaultName string



  resource kv 'Microsoft.KeyVault/vaults@2021-10-01' = {
    name: KeyVaultName
    location: location
    properties: {
       sku : {
                 family: 'A'
                   name: 'standard'
       }


      tenantId: subscription().tenantId
      accessPolicies: []
      enableSoftDelete: enableSoftDelete
      enablePurgeProtection: enablePurgeProtection
      enableRbacAuthorization: enableRBACAuthorization
      publicNetworkAccess: publicNetworkAccess
    }
    tags: tags
  }
