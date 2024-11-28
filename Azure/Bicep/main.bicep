 targetScope = 'resourceGroup'

 module vnet 'modules/vnet.bicep' = {
  name: 'vnet'
  params: {
    vnetName: 'harderwijk-vnet'
    location: 'westeurope'
    vnetAddressPrefix: '10.1.10.0/24'
  }
 }

module vm 'modules/vm.bicep' = {
  name: 'vm'
  params: {
    vmName: 'harderwijk-vm'
    location: 'westeurope'
    subnetID: vnet.outputs.subnetIds[0]
  }
}
