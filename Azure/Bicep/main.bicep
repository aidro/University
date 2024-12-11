 param location string = 'westeurope'
 param localNetworkGatewayName string = 'Zachtewijk-local'
 param onPremAddressPrefix string = '10.0.0.0/8'
 param onPremIPAddress string = '145.37.235.113'
 param vpnConnectionName string = 'Azure-Zachtewijk'
 param instanceCount int = 1
 @secure()
 param adminUsername string
 @secure() 
 param adminPassword string 
 param domainName string = 'draak-hosting.nl'
 param netbiosName string = 'DRAAK-HOSTING'
 param domainMode string = 'Default'
 param domainAdminUsername string = 'knaakadmin'
 @secure()
 param joinAccountPassword string
@secure()
param safeModeAdminPassword string
@allowed([
  'test'
  'prod'
])
param env string = 'test'

 targetScope = 'resourceGroup'

 module vnet 'modules/vnet.bicep' = {
  name: 'vnet'
  params: {
    vnetName: 'zachtewijk-vnet-${env}'
    location: location
    vnetAddressPrefix: '20.1.10.0/24'
  }
 }

module admaster 'modules/admaster.bicep' = {
  name: 'admaster'
  params: {
    vmName: 'ad0-master'
    location: location
    subnetID: vnet.outputs.subnetIds[0]
    vmIpAddress: '20.1.10.10'
    adminUsername: adminUsername
    adminPassword: adminPassword
    domainMode: domainMode
    domainName: domainName
    netbiosName: netbiosName
    safeModeAdminPassword: safeModeAdminPassword
  }
}


module adslave 'modules/adslave.bicep' = [for i in range(0, instanceCount): {
  name: 'ad${i}'
  params: {
    vmName: 'ad${i}-slave'
    location: location
    subnetID: vnet.outputs.subnetIds[0]
    vmIpAddress: '20.1.10.2${i}'
    adminUsername: adminUsername
    adminPassword: adminPassword
    domainMode: domainMode
    domainName: domainName
    netbiosName: netbiosName
    safeModeAdminPassword: safeModeAdminPassword
    joinAccountPassword: joinAccountPassword
  }
  dependsOn: [
    admaster
  ]
}
]


// module vpnGateway 'modules/vng.bicep' = {
//   name: 'vpnGateway'
//   params: {
//     location: location
//     publicIpName: 'Zachtewijk-Public-1-${env}' 
//     VpnGateway: 'VNG-Zachtewijk-${env}'
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

// module exchange 'modules/exchange.bicep' = {
//   name: 'exchange-draak'
//   params: {
//     location: location
//     subnetID: vnet.outputs.subnetIds[0]
//     adminUsername: adminUsername
//     adminPassword: adminPassword
//     joinAccountPassword: joinAccountPassword
//   }
//   dependsOn: [
//     vnet
//     admaster
//   ]
// }
