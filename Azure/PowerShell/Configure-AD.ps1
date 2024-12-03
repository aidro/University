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

# Get the computer name
$computerName = $env:COMPUTERNAME

# Check if the computer name matches "ad0"
if ($computerName -eq "ad0-knaak") {
    Write-Output "Computer name is 'ad0'. Proceeding with domain creation..."

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

} elseif ($computerName -eq "ad1-knaak") {
    Import-Module ServerManager

    Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

    Import-Module ActiveDirectory

    $DomainName = "knaak-hosting.nl"
    $NetbiosName = "KNAAK-HOSTING"
    $DomainMode = "Win2016"
    $SafeModeAdminPasswordPlain = "Knaakhosting4.2!"

    $SafeModeAdministratorPassword = ConvertTo-SecureString $SafeModeAdminPasswordPlain -AsPlainText -Force

    Install-ADDSForest -DomainName $DomainName -DomainNetbiosName $NetbiosName -DomainMode $DomainMode -SafeModeAdministratorPassword $SafeModeAdministratorPassword -Force -NoRebootOnCompletion
    
} else {
    Write-Output "Computer name is not 'ad0'. Domain creation aborted."
}