using '../main.bicep'

param env = 'uat'

param projectName = 'nimbus'

param enablePurgeProtection = true

param enableRBACAuthorization = true

param publicNetworkAccess = 'Enabled'

param enableSoftDelete = true

param location = 'East US' 

param storageAccountName = '${projectName}${env}storage'



// param sku = {
//   family: 'A'
//   name: 'standard'
// }


param skuName = 'Standard_LRS'

