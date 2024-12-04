 param location string = 'westeurope'
 param localNetworkGatewayName string = 'Harderwijk-local'
 param onPremAddressPrefix string = '10.0.0.0/8'
 param onPremIPAddress string = '145.37.235.113'
 param vpnConnectionName string = 'Azure-Harderwijk'
 param instanceCount int = 1
 @secure()
 param adminUsername string
 @secure() 
 param adminPassword string 
 param domainName string = 'draak-hosting.nl'
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
    vnetName: 'harderwijk-vnet-${env}'
    location: location
    vnetAddressPrefix: '20.1.10.0/24'
  }
 }

module admaster 'modules/admaster.bicep' = {
  name: 'ad1-knaak'
  params: {
    vmName: 'ad1-knaak'
    location: location
    subnetID: vnet.outputs.subnetIds[0]
    vmIpAddress: '20.1.10.10'
    adminUsername: adminUsername
    adminPassword: adminPassword
    domainMode: 'Win2019'
    domainName: 'draak-hosting.nl'
    netbiosName: 'DRAAK-HOSTING'
    safeModeAdminPassword: safeModeAdminPassword
  }
}


module adslave 'modules/adslave.bicep' = [for i in range(0, instanceCount): {
  name: 'ad-slave${i}'
  params: {
    vmName: 'ad${i}-draak-${env}'
    location: location
    subnetID: vnet.outputs.subnetIds[0]
    vmIpAddress: '20.1.10.1${i}'
    adminUsername: adminUsername
    adminPassword: adminPassword
    domainMode: 'Win2019'
    domainName: 'draak-hosting.nl'
    netbiosName: 'DRAAK-HOSTING'
    safeModeAdminPassword: safeModeAdminPassword
  }
  dependsOn: [
    admaster
  ]
}
]


module vpnGateway 'modules/vng.bicep' = {
  name: 'vpnGateway'
  params: {
    location: location
    publicIpName: 'Zachtewijk-Public-1-${env}' 
    VpnGateway: 'VNG-Zachtewijk-${env}'
    subnetID: vnet.outputs.subnetIds[1]
    localNetworkGatewayName: localNetworkGatewayName
    onPremAddressPrefix: onPremAddressPrefix
    onPremIPAddress: onPremIPAddress
    vpnConnectionName: vpnConnectionName
    sharedKey: '2bf5c01cd020e89266627fb815e51129a8ee44439c1a0a4f86686921'
  }
  dependsOn: [
    vnet
  ]
} 

module exchange 'modules/exchange.bicep' = {
  name: 'exchange'
  params: {
    location: location
    subnetID: vnet.outputs.subnetIds[0]
    adminUsername: adminUsername
    adminPassword: adminPassword
    joinAccountPassword: joinAccountPassword
  }
  dependsOn: [
    vnet
  ]
}
