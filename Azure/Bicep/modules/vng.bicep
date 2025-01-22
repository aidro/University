param location string
param VpnGateway string
param publicIpName string
param subnetID string
param localNetworkGatewayName string
param onPremIPAddress string
param onPremAddressPrefix string
param vpnConnectionName string
param sharedKey string

resource publicIp 'Microsoft.Network/publicIPAddresses@2020-06-01' = {
  name: publicIpName
  location: 'West Europe'
  properties: {
    publicIPAllocationMethod: 'Static'
  }
  sku: {
    name: 'Standard'
}
}

resource vpnGateway 'Microsoft.Network/virtualNetworkGateways@2020-06-01' = {
  name: VpnGateway
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'vnetGatewayConfig'
        properties: {
          publicIPAddress: {
            id: publicIp.id
          }
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: subnetID
          }
        }
      }
    ]
    gatewayType: 'Vpn'
    vpnType: 'RouteBased'
    enableBgp: false
    sku: {
      name: 'VpnGw1'
      tier: 'VpnGw1'
    }
  }
}

resource localNetworkGateway 'Microsoft.Network/localNetworkGateways@2020-06-01' = {
  name: localNetworkGatewayName
  location: location
  properties: {
    gatewayIpAddress: onPremIPAddress
    localNetworkAddressSpace: {
      addressPrefixes: [
        onPremAddressPrefix
      ]
    }
  }
}

resource vpnConnection 'Microsoft.Network/connections@2020-11-01' = {
  name: vpnConnectionName
  location: location
  properties: {
    connectionType: 'IPsec'
    virtualNetworkGateway1: {
      id: vpnGateway.id
      properties: {}
    }
    localNetworkGateway2: {
      id: localNetworkGateway.id
      properties: {}
    }
    sharedKey: sharedKey
    ipsecPolicies: [{
      dhGroup: 'DHGroup14'
      ikeEncryption: 'AES128'
      ikeIntegrity: 'SHA256'
      ipsecEncryption: 'AES128'
      ipsecIntegrity: 'SHA256'
      pfsGroup: 'ECP384'
      saDataSizeKilobytes: 0
      saLifeTimeSeconds: 5000
    }]
    dpdTimeoutSeconds: 45
    // Responder mode because Hanze
    connectionMode: 'ResponderOnly'
  }
}
