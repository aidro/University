param vmName string = 'exchange1'
param location string
param subnetID string
param vmIpAddress string = '10.1.10.51'
@secure()
param adminPassword string
param exchangeUsername string = 'exchange2'
param adminUsername string
param domainName string = 'knaak-hosting.nl'
param joinAccountUsername string = 'KNAAK-HOSTING\\knaakadmin'
@secure()
param joinAccountPassword string
param domainJoinOptions int = 3

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
      vmSize: 'Standard_D4as_v5'
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

resource domainJoinExtension 'Microsoft.Compute/virtualMachines/extensions@2022-08-01' = {
  parent: virtualMachine
  name: 'DomainJoin'
  location: location
  properties: {
    publisher: 'Microsoft.Compute'
    type: 'JsonADDomainExtension'
    typeHandlerVersion: '1.3'
    settings: {
      Name: domainName
      OUPath: 'OU=Servers,DC=knaak-hosting,DC=nl'
      User: '${domainName}\\${exchangeUsername}'
      options: domainJoinOptions
      Restart: 'true'
    }
    protectedSettings: {
      Password: joinAccountPassword
    }
  }
}

resource ExchangeRequirements 'Microsoft.Compute/virtualMachines/extensions@2022-08-01' = {
  parent: virtualMachine
  name: 'ExchangeRequirements'
  location: location
  properties: {
    publisher: 'Microsoft.Compute'
    type: 'CustomScriptExtension'
    typeHandlerVersion: '1.10'
    autoUpgradeMinorVersion: true
    settings: {
      fileUris: [
        'https://raw.githubusercontent.com/aidro/University/refs/heads/main/Azure/PowerShell/exchange-requirements.ps1'
        'https://raw.githubusercontent.com/aidro/University/refs/heads/main/Azure/PowerShell/exchange-installer.ps1'
      ]
        }
    protectedSettings: {
      commandToExecute: 'powershell -ExecutionPolicy Unrestricted -File exchange-requirements.ps1'
    }
  } 
  dependsOn: [
    domainJoinExtension
  ]
}
