
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
    -NoRebootOnCompletion `
    -Force

Write-Output "Domain '$DomainName' has been created successfully on 'ad0'."

# Wait for AD services to start and ensure they are running
Write-Output "Waiting for Active Directory services to start..."
$Services = @("NTDS", "Netlogon", "DNS")
foreach ($Service in $Services) {
    while ((Get-Service -Name $Service).Status -ne 'Running') {
        Write-Output "Waiting for service $Service to start..."
        Start-Sleep -Seconds 5
    }
}
Write-Output "All required services are running."

# Create the Organizational Unit
try {
    New-ADOrganizationalUnit -Name "Servers" -Path "DC=$($DomainName.Split('.')[0]),DC=$($DomainName.Split('.')[1])"
    Write-Output "Organizational Unit 'Servers' has been created."
} catch {
    Write-Error "Failed to create the Organizational Unit. Error: $_"
}

# Reboot the server
Restart-Computer -Force