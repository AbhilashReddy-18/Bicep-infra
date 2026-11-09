using '../main.bicep'

param env = 'dev'


param projectName = 'nimbus'

param enablePurgeProtection = true

param enableRBACAuthorization = false

param publicNetworkAccess = 'Enabled'

param enableSoftDelete = true

param location = 'West US'  


param storageAccountName = '${projectName}${env}storage'

// param sku = {
//   family: 'A'
//   name: 'standard'
// }





param skuName = 'Standard_LRS'





