
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

$scriptBlock = {
	New-ADOrganizationalUnit -Name "Servers" -Path "DC=draak-hosting,DC=nl"
}
# Convert script block to a Base64 encoded string to pass it to the scheduled task
$encodedCommand = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($scriptBlock.ToString()))
# Creating the scheduled task
$action = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument "-EncodedCommand $encodedCommand"
$trigger = New-ScheduledTaskTrigger -AtStartup
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "ContinueAfterReboot" -Description "My task to continue script execution after reboot"
# Restart the computer (uncomment in actual use)
Restart-Computer -Force