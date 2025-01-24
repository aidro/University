// Params for VM creation
param vmName string = 'exchange1-draak'
param location string
param subnetID string
param vmIpAddress string = '20.1.10.51'
@secure()
param adminPassword string
param adminUsername string
// Params for joining AD
param domainName string = 'draak-hosting.nl'
@secure()
param joinAccountPassword string
param domainJoinOptions int = 3

// Create the network interface card
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

// Create the VM and add the NIC
resource virtualMachine 'Microsoft.Compute/virtualMachines@2024-07-01' = {
  name: vmName
  location: location
  // VM SKU
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_D4as_v5'
    }
    // VM login and name
    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    // VM image
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2022-Datacenter'
        version: 'latest'
      }
      // VM Disk properties
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
        }
        diskSizeGB: 128
      }
    }
    // Add the NIC to VM
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterface.id
        }
      ]
    }
  }
}

// Join the VM to the domain
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
      OUPath: 'OU=Servers,DC=draak-hosting,DC=nl'
      User: '${domainName}\\${adminUsername}'
      options: domainJoinOptions
      Restart: 'true'
    }
    protectedSettings: {
      Password: joinAccountPassword
    }
  }
}

//Run script to install the requirements to setup Exchange
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
        'https://raw.githubusercontent.com/aidro/University/refs/heads/Testing/Azure/PowerShell/JoinAD.ps1'
      ]
        }
    protectedSettings: {
      commandToExecute: 'powershell -ExecutionPolicy Unrestricted -File JoinAD.ps1'
    }
  } 
}
