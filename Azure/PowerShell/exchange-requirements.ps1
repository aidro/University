$domainName = "knaak-hosting.nl" 
$domainUser = "knaakadmin@knaak-hosting.nl" 
$domainPassword = "Knaakhosting4.2!"

Install-WindowsFeature -Name Web-Server, Web-Mgmt-Tools, Web-Mgmt-Console -IncludeManagementTools

Install-WindowsFeature Server-Media-Foundation, RPC-over-HTTP-proxy, RSAT-Clustering, RSAT-Clustering-CmdInterface, RSAT-Clustering-Mgmt, RSAT-Clustering-PowerShell, WAS-Process-Model, Web-Asp-Net45, Web-Basic-Auth, Web-Client-Auth, Web-Digest-Auth, Web-Dir-Browsing, Web-Dyn-Compression, Web-Http-Errors, Web-Http-Logging, Web-Http-Redirect, Web-Http-Tracing, Web-ISAPI-Ext, Web-ISAPI-Filter, Web-Lgcy-Mgmt-Console, Web-Metabase, Web-Mgmt-Console, Web-Mgmt-Service, Web-Net-Ext45, Web-Request-Monitor, Web-Server, Web-Stat-Compression, Web-Static-Content, Web-Windows-Auth, Web-WMI, Windows-Identity-Foundation, RSAT-ADDS

Write-Output "Installeer .NET Framework 4.8..."
#$netInstaller = "https://go.microsoft.com/fwlink/?linkid=2088631"
#Invoke-WebRequest -Uri $netInstaller -OutFile "C:\Temp\ndp48-x86-x64-allos-enu.exe"
#Start-Process -FilePath "C:\Temp\ndp48-x86-x64-allos-enu.exe" -ArgumentList "/quiet", "/norestart" -Wait

# Visual vc_redsit
Write-Output "Installeer vc_redist"
#$vc2012Installer = "https://aka.ms/vs/17/release/vc_redist.x64.exe"
#Invoke-WebRequest -Uri $vc2012Installer -OutFile "C:\Temp\vc_redist.x64.exe"
#Start-Process -FilePath "C:\Temp\vc_redist.x64.exe" -ArgumentList "/quiet", "/norestart" -Wait

# IIS URL Rewrite Module
Write-Output "Installeer IIS URL Rewrite Module"
#$urlRewriteInstaller = "https://download.microsoft.com/download/1/2/8/128E2E22-C1B9-44A4-BE2A-5859ED1D4592/rewrite_amd64_en-US.msi"
#Invoke-WebRequest -Uri $urlRewriteInstaller -OutFile "C:\Temp\rewrite_amd64_en-US.msi"
#Start-Process -FilePath "msiexec.exe" -ArgumentList "/i C:\Temp\rewrite_amd64_en-US.msi /quiet /norestart" -Wait

Write-Output "Installeer ucmaRuntime"
$ucmaRuntime = "https://download.microsoft.com/download/2/C/4/2C47A5C1-A1F3-4843-B9FE-84C0032C61EC/UcmaRuntimeSetup.exe"
Invoke-WebRequest -Uri $ucmaRuntime -OutFile "C:\Temp\UcmaRuntimeSetup.exe"
Start-Process -FilePath "C:\Temp\UcmaRuntimeSetup.exe" -ArgumentList "/quiet", "/norestart" -Wait

Write-Output "Server toevoegen aan domein $domainName..."
#$securePassword = ConvertTo-SecureString $domainPassword -AsPlainText -Force
#$credential = New-Object System.Management.Automation.PSCredential ($domainUser, $securePassword)
#Add-Computer -DomainName $domainName -Credential $credential -Restart -Force
