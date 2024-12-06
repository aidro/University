param (
    [Parameter(Mandatory = $true)]
    [string]$DomainName,
    [Parameter(Mandatory = $true)]
    [string]$DomainMode,
    [Parameter(Mandatory = $true)]
    [string]$SafeModeAdministratorPasswordPlain,
    [Parameter(Mandatory = $true)]
    [string]$DomainAdminUsername,
    [Parameter(Mandatory = $true)]
    [string]$DomainAdminPasswordPlain
)
 
 # Import required modules
 Import-Module ServerManager

 # Install the Active Directory Domain Services role
 Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
 
 # Import Active Directory module
 Import-Module ActiveDirectory
 Start-Transcript -Path C:\DCPromotionLog.txt
 # Define variables

 
 # Convert passwords to secure strings
 $SafeModeAdministratorPassword = ConvertTo-SecureString $SafeModeAdminPasswordPlain -AsPlainText -Force
 $DomainAdminPassword = ConvertTo-SecureString $DomainAdminPasswordPlain -AsPlainText -Force
 
 # Create a PSCredential object for the domain admin
 $DomainAdminCredential = New-Object System.Management.Automation.PSCredential($DomainAdminUsername, $DomainAdminPassword)
 
 # Add the server as a domain controller to the existing domain
 Install-ADDSDomainController `
     -DomainName $DomainName `
     -SafeModeAdministratorPassword $SafeModeAdministratorPassword `
     -Credential $DomainAdminCredential `
     -ReplicationSourceDC "ad1-domain-test.kraak-hosting.nl" `
     -NoRebootOnCompletion:$false `
     -Force 
 