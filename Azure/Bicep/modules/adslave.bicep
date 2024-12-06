param vmName string
param location string
param subnetID string
param vmIpAddress string
@secure()
param adminPassword string
param adminUsername string
param domainName string 
param netbiosName string
param domainMode string
@secure()
param safeModeAdminPassword string
param domainJoinOptions int = 3
@secure()
param joinAccountPassword string

resource publicIPAddress 'Microsoft.Network/publicIPAddresses@2024-03-01' = {
  name: '${vmName}-pubIp2'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource networkInterface 'Microsoft.Network/networkInterfaces@2024-03-01' =  {
  name: '${vmName}-NIC'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig'
        properties: {
          privateIPAllocationMethod: 'static'
          privateIPAddress: vmIpAddress
          subnet: {
            id: subnetID
          }
          publicIPAddress: {
            id: publicIPAddress.id
          }
        }
      }
    ]
  }
}

resource virtualMachine 'Microsoft.Compute/virtualMachines@2024-07-01' = {
  name: vmName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B2s'
    }
    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2022-Datacenter'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
        }
        diskSizeGB: 128
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterface.id
        }
      ]
    }
  }
}

resource adInstallExtension 'Microsoft.Compute/virtualMachines/extensions@2022-08-01' = {
  parent: virtualMachine
  name: 'ADInstall'
  location: location
  properties: {
    publisher: 'Microsoft.Compute'
    type: 'CustomScriptExtension'
    typeHandlerVersion: '1.10'
    autoUpgradeMinorVersion: true
    settings: {
      fileUris: [
        'https://raw.githubusercontent.com/aidro/University/refs/heads/Testing/Azure/PowerShell/JoinAD.ps1'
      ]
        }
    protectedSettings: {
      safeModeAdminPassword: safeModeAdminPassword
      commandToExecute: 'powershell.exe -ExecutionPolicy Unrestricted -File JoinAD.ps1 -DomainName "${domainName}" -NetbiosName "${netbiosName}" -DomainMode "${domainMode}" -SafeModeAdministratorPassword "$(safeModeAdminPassword)"'
    }
  }
}

// resource domainJoinExtension 'Microsoft.Compute/virtualMachines/extensions@2022-08-01' = {
//   parent: virtualMachine
//   name: 'DomainJoin'
//   location: location
//   properties: {
//     publisher: 'Microsoft.Compute'
//     type: 'JsonADDomainExtension'
//     typeHandlerVersion: '1.3'
//     settings: {
//       Name: domainName
//       OUPath: 'OU=Servers,DC=draak-hosting,DC=nl'
//       User: '${domainName}\\${adminUsername}'
//       options: domainJoinOptions
//       Restart: 'true'
//     }
//     protectedSettings: {
//       Password: joinAccountPassword
//     }
//   }
// }
