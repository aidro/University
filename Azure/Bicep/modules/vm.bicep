param vmName string
param location string
param subnetID string
param vmIpAddress string
param adminPassword string
param adminUsername string

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

// Custom Script Extension to Install Active Directory
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
      fileUris: []
      commandToExecute: '''
        Import-Module ServerManager

        Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

        Import-Module ActiveDirectory

        $DomainName = "knaak-hosting.nl"
        $NetbiosName = "KNAAK-HOSTING"
        $DomainMode = "Win2016"
        $SafeModeAdminPasswordPlain = "Knaakhosting4.2!"

        $SafeModeAdministratorPassword = ConvertTo-SecureString $SafeModeAdminPasswordPlain -AsPlainText -Force

        Install-ADDSForest -DomainName $DomainName -DomainNetbiosName $NetbiosName -DomainMode $DomainMode -SafeModeAdministratorPassword $SafeModeAdministratorPassword -Force -NoRebootOnCompletion
      '''
    }
  }
}
