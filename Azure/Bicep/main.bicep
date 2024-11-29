 param location string = 'westeurope'
 param localNetworkGatewayName string = 'Harderwijk-local'
 param onPremAddressPrefix string = '10.0.0.0/8'
 param onPremIPAddress string = '145.37.235.113'
 param vpnConnectionName string = 'Azure-Harderwijk'
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
    location: location
    vnetAddressPrefix: '10.1.10.0/24'
  }
 }

module vm 'modules/vm.bicep' = [for i in range(0, instanceCount): {
  name: 'vm-${i}'
  params: {
    vmName: 'ad${i}-knaak'
    location: location
    subnetID: vnet.outputs.subnetIds[0]
    vmIpAddress: '10.1.10.1${i}'
    adminUsername: adminUsername
    adminPassword: adminPassword
  }
}
]

// module vpnGateway 'modules/vpngateway.bicep' = {
//   name: 'vpnGateway'
//   params: {
//     location: location
//     publicIpName: 'Harderwijk1-public' 
//     VpnGateway: 'Harderwijk-gateway'
//     subnetID: vnet.outputs.subnetIds[1]
//     localNetworkGatewayName: localNetworkGatewayName
//     onPremAddressPrefix: onPremAddressPrefix
//     onPremIPAddress: onPremIPAddress
//     vpnConnectionName: vpnConnectionName
//     sharedKey: '2bf5c01cd020e89266627fb815e51129a8ee44439c1a0a4f86686921'
//   }
//   dependsOn: [
//     vnet
//   ]
// } 

