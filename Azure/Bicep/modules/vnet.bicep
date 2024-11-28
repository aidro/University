param vnetName string
param location string
param vnetAddressPrefix array
// param subnetName string
// param subnetAddressPrefix string
// param securityGroup object

//subnets are defined in numbers starting from 0 in CreateResources.bicep+
param subnetConfigs array = [
  {
    name: 'Servers'
    addressPrefix: '10.1.10.0/25'
    nsgName: 'Servers-NSG'
  }
  {
    name: 'GatewaySubnet'
    addressPrefix: '10.1.10.224/27'
    nsgName: 'GatewaySubnet-NSG'
  }
]

resource nsg 'Microsoft.Network/networkSecurityGroups@2024-03-01' = {
  name: 'Servers-NSG'
  location: location
  properties: {
    securityRules: [
      {
        name: 'AllowRDP'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          direction: 'Inbound'
          priority: 100
          description: 'Allow RDP'
        }
      }
    ]
  }
}

resource vnet 'Microsoft.Network/virtualNetworks@2024-03-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: vnetAddressPrefix
    }
    subnets: [for subnet in subnetConfigs: {
      name: subnet.name
      properties: {
        addressPrefix: subnet.addressPrefix
        networkSecurityGroup: {
          id: resourceId('Microsoft.Network/networkSecurityGroups', subnet.nsgName)
        }
        delegations: (subnet.name == 'GatewaySubnet' ? [
          {
            name: 'VirtualNetworkGateway'
            properties: {
              serviceName: 'Microsoft.Network/virtualNetworkGateways'
            }
          }
        ] : [])
      }
    }]
  }
}
