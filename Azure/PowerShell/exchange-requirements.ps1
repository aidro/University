$domainName = "knaak-hosting.nl" 
$domainUser = "knaakadmin@knaak-hosting.nl" 
$domainPassword = "Knaakhosting4.2!"

Install-WindowsFeature -Name Web-Server, Web-Mgmt-Tools, Web-Mgmt-Console -IncludeManagementTools

Install-WindowsFeature Server-Media-Foundation, RPC-over-HTTP-proxy, RSAT-Clustering, RSAT-Clustering-CmdInterface, RSAT-Clustering-Mgmt, RSAT-Clustering-PowerShell, WAS-Process-Model, Web-Asp-Net45, Web-Basic-Auth, Web-Client-Auth, Web-Digest-Auth, Web-Dir-Browsing, Web-Dyn-Compression, Web-Http-Errors, Web-Http-Logging, Web-Http-Redirect, Web-Http-Tracing, Web-ISAPI-Ext, Web-ISAPI-Filter, Web-Lgcy-Mgmt-Console, Web-Metabase, Web-Mgmt-Console, Web-Mgmt-Service, Web-Net-Ext45, Web-Request-Monitor, Web-Server, Web-Stat-Compression, Web-Static-Content, Web-Windows-Auth, Web-WMI, Windows-Identity-Foundation, RSAT-ADDS, NET-WCF-HTTP-Activation45

Write-Output "Installeer .NET Framework 4.8..."
$netInstaller = "https://go.microsoft.com/fwlink/?linkid=2088631"
Invoke-WebRequest -Uri $netInstaller -OutFile "C:\Temp\ndp48-x86-x64-allos-enu.exe"
Start-Process -FilePath "C:\Temp\ndp48-x86-x64-allos-enu.exe" -ArgumentList "/quiet", "/norestart" -Wait

# Visual C++ 2012 Redistributable
Write-Output "Installeer vc_redist 2012"
$vc2012Installer = "https://aka.ms/vs/17/release/vc_redist.x64.exe"
Invoke-WebRequest -Uri $vc2012Installer -OutFile "C:\Temp\vc_redist.x64.exe"
Start-Process -FilePath "C:\Temp\vc_redist.x64.exe" -ArgumentList "/quiet", "/norestart" -Wait

# Visual C++ 2013 Redistributable
Write-Output "Installeer vc_redist 2013"
$vc2013Installer = "https://download.microsoft.com/download/9/3/8/938AD4D0-BF2A-4C1D-8E45-7C460CE632BF/vcredist_x64.exe"
Invoke-WebRequest -Uri $vc2013
#  Determine the directory where the script is running
# $scriptDirectory = Split-Path -Parent $MyInvocation.MyCommand.Definition

#  Ensure the C:\Scripts directory exists
# New-Item -ItemType Directory -Path 'C:\Scripts' -Force

#  Copy 'exchange-installer.ps1' to 'C:\Scripts'
# Copy-Item -Path "$scriptDirectory\exchange-installer.ps1" -Destination 'C:\Scripts\exchange-installer.ps1' -Force

# # Schedule 'exchange-installer.ps1' to run at startup
# $action = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument '-ExecutionPolicy Unrestricted -File "C:\Scripts\exchange-installer.ps1"'
# $trigger = New-ScheduledTaskTrigger -AtStartup
# $principal = New-ScheduledTaskPrincipal -UserId 'SYSTEM' -LogonType ServiceAccount -RunLevel Highest
# $task = New-ScheduledTask -Action $action -Trigger $trigger -Principal $principal

# Register-ScheduledTask -TaskName 'RunExchangeInstaller' -InputObject $task

# Write-Output "Server toevoegen aan domein $domainName..."
# $securePassword = ConvertTo-SecureString $domainPassword -AsPlainText -Force
# $credential = New-Object System.Management.Automation.PSCredential ($domainUser, $securePassword)
# Add-Computer -DomainName $domainName -Credential $credential -Restart -Force
