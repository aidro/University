 param instanceCount int = 2
 @secure()
 param adminUsername string
 @secure() 
 param adminPassword string


 targetScope = 'resourceGroup'

 module vnet 'modules/vnet.bicep' = {
  name: 'vnet'
  params: {
    vnetName: 'harderwijk-vnet'
    location: 'westeurope'
    vnetAddressPrefix: '10.1.10.0/24'
  }
 }

module vm 'modules/vm.bicep' = [for i in range(0, instanceCount): {
  name: 'vm-${i}'
  params: {
    vmName: 'ad${i}-knaak'
    location: 'westeurope'
    subnetID: vnet.outputs.subnetIds[0]
    vmIpAddress: '10.1.10.1${i}'
    adminUsername: adminUsername
    adminPassword: adminPassword
  }
}
]
