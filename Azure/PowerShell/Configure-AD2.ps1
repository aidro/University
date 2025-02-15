Import-Module ServerManager

Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

Import-Module ActiveDirectory

$DomainName = "knaak-hosting.nl"
$NetbiosName = "KNAAK-HOSTING"
$DomainMode = "Win2016"
$SafeModeAdminPasswordPlain = "Knaakhosting4.2!"

$SafeModeAdministratorPassword = ConvertTo-SecureString $SafeModeAdminPasswordPlain -AsPlainText -Force

Install-ADDSForest -DomainName $DomainName -DomainNetbiosName $NetbiosName -DomainMode $DomainMode -SafeModeAdministratorPassword $SafeModeAdministratorPassword -Force -NoRebootOnCompletion