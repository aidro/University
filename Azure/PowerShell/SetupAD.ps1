# Import the Server Manager module
Import-Module ServerManager

# Install the AD DS role
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

# Import the Active Directory module
Import-Module ActiveDirectory

$InstallForestParams = @{
    DomainMode = "Default"
    DomainName = "draak-hosting.nl"
    SafeModeAdministratorPassword = ConvertTo-SecureString "Knaakhosting4.2!" -AsPlainText -Force 
    DomainNetbiosName = "DRAAK-HOSTING"
    ForestMode = "Default"
    InstallDns = $true
    NoRebootOnCompletion = $false
    Force = $true
}

Install-ADDSForest @InstallForestParams
