//VM Parameters
param vmName string
param location string
param subnetID string
param vmIpAddress string
@secure()
param adminPassword string
param adminUsername string
//Password to join AD
@secure()
param safeModeAdminPassword string

//Create the public IP address(deprecated due to security reasons)
// resource publicIPAddress 'Microsoft.Network/publicIPAddresses@2024-03-01' = {
//   name: '${vmName}-pubIp2'
//   location: location
//   sku: {
//     name: 'Standard'
//   }
//   properties: {
//     publicIPAllocationMethod: 'Static'
//   }
// }

//Create the network interface card
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
          // publicIPAddress: {
          //   id: publicIPAddress.id
          // }
        }
      }
    ]
  }
}

//Create the VM and add the NIC
resource virtualMachine 'Microsoft.Compute/virtualMachines@2024-07-01' = {
  name: vmName
  location: location
  //VM SKU
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B2s'
    }
    //VM login and name
    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    //VM image
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2022-Datacenter'
        version: 'latest'
      }
      //VM disk properties
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
        }
        diskSizeGB: 128
      }
    }
    //Add the NIC to the VM
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterface.id
        }
      ]
    }
  }
}
//Run script to install the AD and add the VM to the domain
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
        'https://raw.githubusercontent.com/aidro/University/refs/heads/Testing/Azure/PowerShell/InstallAD2.ps1'
      ]
        }
    protectedSettings: {
      safeModeAdminPassword: safeModeAdminPassword
      commandToExecute: 'powershell.exe -ExecutionPolicy Unrestricted -File InstallAD2.ps1'    
    }
  }
}
