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
  location: location
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

// Define the local network gateway
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

// Define the VPN connection
// resource vpnConnection 'Microsoft.Network/connections@2020-06-01' = {
//   name: vpnConnectionName
//   location: location
//   properties: {
//     virtualNetworkGateway1: {
//       id: vpnGateway.id
//       properties: {

//       }
//     }
//     localNetworkGateway2: {
//       id: localNetworkGateway.id
//       properties: {
//       }
//     }
//     connectionType: 'IPsec'
//     sharedKey: '2bf5c01cd020e89266627fb815e51129a8ee44439c1a0a4f86686921'
//   }
// }

resource vpnConnection 'Microsoft.Network/connections@2020-11-01' = {
  name: vpnConnectionName
  location: location
  properties: {
    connectionType: 'IPsec'
    virtualNetworkGateway1: {
      id: vpnGateway.id
    }
    localNetworkGateway2: {
      id: localNetworkGateway.id
    }
    sharedKey: sharedKey
    // Optional: Add IPsec policies or routing configurations if needed
  }
}
