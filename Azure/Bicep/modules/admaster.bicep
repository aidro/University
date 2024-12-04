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

resource publicIPAddress 'Microsoft.Network/publicIPAddresses@2024-03-01' = {
  name: '${vmName}-pubIp'
  location: location
  properties: {
    publicIPAllocationMethod: 'Dynamic'
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

resource SetupAD 'Microsoft.Compute/virtualMachines/extensions@2022-08-01' = {
  parent: virtualMachine
  name: 'SetupAD'
  location: location
  properties: {
    publisher: 'Microsoft.Compute'
    type: 'CustomScriptExtension'
    typeHandlerVersion: '1.10'
    autoUpgradeMinorVersion: true
    settings: {
      fileUris: [
        'https://raw.githubusercontent.com/aidro/University/refs/heads/main/Azure/PowerShell/SetupAD.ps1?token=GHSAT'
      ]
        }
    protectedSettings: {
      safeModeAdminPassword: safeModeAdminPassword
      commandToExecute: 'powershell.exe -ExecutionPolicy Unrestricted -File SetupAD.ps1 -DomainName "${domainName}" -NetbiosName "${netbiosName}" -DomainMode "${domainMode}" -SafeModeAdministratorPassword "$(safeModeAdminPassword)"'
    }
  }
}
