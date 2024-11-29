# Download and save this script as AD-aanmaken.ps1 in a folder of your choice
# Replace the parameters with your own values
param (
    [Parameter(Mandatory=$true)]
    [string]$DomainName,
    [Parameter(Mandatory=$true)]
    [string]$NetbiosName,
    [Parameter(Mandatory=$true)]
    [string]$DomainMode,
    [Parameter(Mandatory=$true)]
    [string]$SafeModeAdministratorPassword
)

# Import the Server Manager module
Import-Module ServerManager

# Install the AD DS role
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

# Import the Active Directory module
Import-Module ActiveDirectory

# Create a new domain
New-ADDomain -Name $DomainName -NetbiosName $NetbiosName -DomainMode $DomainMode -SafeModeAdministratorPassword $SafeModeAdministratorPassword
