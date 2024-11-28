param vnetName string
param location string
param vnetAddressPrefix string
param subnetName string
param subnetAddressPrefix string
// param securityGroup object

resource vnet 'Microsoft.Network/virtualNetworks@2024-03-01' = {
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
        name: subnetName
        properties: {
          addressPrefix: subnetAddressPrefix
          // securityGroup: {
          //   id: securityGroup.id
          // }
        }
      }
    ]
  }
}
