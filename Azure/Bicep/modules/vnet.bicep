param vnetName string
param location string
param vnetAddressPrefix string

param subnetConfigs array = [
  {
    name: 'Servers'
    addressPrefix: '20.1.10.0/25'
  }
  {
    name: 'GatewaySubnet'
    addressPrefix: '20.1.10.224/27'
  }
]

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2022-01-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }
    dhcpOptions: {
      dnsServers: [
        '20.1.10.10'
        '168.63.129.16'
      ]
    }
    subnets: [for subnet in subnetConfigs: {
      name: subnet.name
      properties: {
        addressPrefix: subnet.addressPrefix
      }
    }
      // {
      //   name: 'Servers'
      //   properties: {
      //     addressPrefix: '10.1.10.0/25'
      //   }
      // }
      // {
      //   //automatic delegation based on name
      //   name: 'GatewaySubnet'
      //   properties: {
      //     addressPrefix: '10.1.10.224/27'
      //   }
      // }

    ]
  }
}

output subnetIds array = [for (subnet, index) in subnetConfigs: resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, subnet.name)]

