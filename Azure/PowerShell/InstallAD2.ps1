$DSRMPassword = ConvertTo-SecureString "Knaakhosting4.2!" -AsPlainText -Force

# Hardcoded domain join credentials
$Username = "draak-hosting\knaakadmin"
$Password = "Knaakhosting4.2!"
$SecurePassword = ConvertTo-SecureString $Password -AsPlainText -Force
$DomainJoinCredential = New-Object System.Management.Automation.PSCredential($Username, $SecurePassword)

# Install AD DS and promote to Domain Controller
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
Install-ADDSDomainController -InstallDns -Credential $DomainJoinCredential -DomainName "draak-hosting.nl" -SafeModeAdministratorPassword $DSRMPassword -Force