param vnetName string
param location string
param vnetAddressPrefix string

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2022-01-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }
    subnets: [
      {
        name: 'Servers'
        properties: {
          addressPrefix: '10.1.10.0/25'
        }
      }
      {
        //automatic delegation based on name
        name: 'GatewaySubnet'
        properties: {
          addressPrefix: '10.1.10.224/27'
        }
      }
    ]
  }
}
