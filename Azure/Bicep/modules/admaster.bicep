//Params for VM Creation
param vmName string
param location string
param subnetID string
param vmIpAddress string
@secure()
param adminPassword string
param adminUsername string
//Params for AD Creation
param domainName string 
param netbiosName string
param domainMode string
@secure()
param safeModeAdminPassword string

//Create the public IP address(deprecated due to security reasons)
// resource publicIPAddress 'Microsoft.Network/publicIPAddresses@2024-03-01' = {
//   name: '${vmName}-pubIp'
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
    //VM Image
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2022-Datacenter'
        version: 'latest'
      }
      //VM Disk properties
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
        }
        diskSizeGB: 128
      }
    }
    //Attach the NIC
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterface.id
        }
      ]
    }
  }
}
//Run script to setup the AD on the VM
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
        'https://raw.githubusercontent.com/aidro/University/refs/heads/Testing/Azure/PowerShell/SetupAD.ps1'
      ]
        }
    protectedSettings: {
      safeModeAdminPassword: safeModeAdminPassword
      commandToExecute: 'powershell.exe -ExecutionPolicy Unrestricted -File SetupAD.ps1 -DomainName "${domainName}" -NetbiosName "${netbiosName}" -DomainMode "${domainMode}" -SafeModeAdministratorPassword "$(safeModeAdminPassword)"'
    }
  }
}
