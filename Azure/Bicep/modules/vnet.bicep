//Params for the creation of the virtual network
param vnetName string
param location string
param vnetAddressPrefix string

//Array with the properties for the subnets
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

//Creation of the actual virtual network
resource virtualNetwork 'Microsoft.Network/virtualNetworks@2022-01-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }
    //DNS servers - custom DNS and Azure DNS
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
    ]
  }
}
//Output subnetIds for use in other modules
output subnetIds array = [for (subnet, index) in subnetConfigs: resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, subnet.name)]

