# AD-aanmaken.ps1

# Download and save this script as AD-aanmaken.ps1 in a folder of your choice
# Replace the parameters with your own values
param (
    [Parameter(Mandatory = $true)]
    [string]$DomainName,
    [Parameter(Mandatory = $true)]
    [string]$NetbiosName,
    [Parameter(Mandatory = $true)]
    [string]$DomainMode,
    [Parameter(Mandatory = $true)]
    [string]$SafeModeAdministratorPassword
)

    # Import the Server Manager module
    Import-Module ServerManager

    # Install the AD DS role
    Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

    # Import the Active Directory module
    Import-Module ActiveDirectory

    # Convert the safe mode administrator password to a secure string
    $securePassword = ConvertTo-SecureString $SafeModeAdministratorPassword -AsPlainText -Force

    # Promote the server to a domain controller by creating a new forest
    Install-ADDSForest `
        -DomainName $DomainName `
        -DomainNetbiosName $NetbiosName `
        -ForestMode $DomainMode `
        -DomainMode $DomainMode `
        -SafeModeAdministratorPassword $securePassword `
        -Force

    Write-Output "Domain '$DomainName' has been created successfully on 'ad0'."

    New-ADOrganizationalUnit -Name "Servers" -Path "DC=draak-hosting,DC=nl"