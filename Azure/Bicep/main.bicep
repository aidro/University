 targetScope = 'resourceGroup'

 module vnet 'modules/vnet.bicep' = {
  name: 'vnet'
  params: {
    vnetName: 'harderwijk-vnet'
    location: 'westeurope'
    vnetAddressPrefix: '10.1.10.0/24'
    subnetName: 'Servers'
    subnetAddressPrefix: '10.1.10.0/25'
    // securityGroup: {
    //   id: 'servers.id'
    // }
  }

 }

 