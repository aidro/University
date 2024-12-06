# Import required modules
Import-Module ServerManager

# Install the Active Directory Domain Services role
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

# Import Active Directory module
Import-Module ActiveDirectory

# Define variables
$DomainName = "draak-hosting.nl"
$SafeModeAdminPasswordPlain = "Knaakhosting4.2!"

# Convert the safe mode administrator password to a secure string
$SafeModeAdministratorPassword = ConvertTo-SecureString $SafeModeAdminPasswordPlain -AsPlainText -Force

# Add the server as a domain controller to the existing domain
Install-ADDSDomainController `
    -DomainName $DomainName `
    -SafeModeAdministratorPassword $SafeModeAdministratorPassword `
    -Force