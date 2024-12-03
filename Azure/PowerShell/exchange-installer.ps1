$isoUrl = "https://download.microsoft.com/download/b/f/7/bf7700c9-c2fd-40be-82cc-7c5330b5f981/ExchangeServer2019-x64-CU14.ISO"
$isoLocalPath = "C:\Temp\ExchangeServer.iso"
$organizationName = "knaak-hosting"
Write-Output $isoUrl

Invoke-WebRequest -Uri $isoUrl -OutFile $isoLocalPath

# Functie om de ISO te koppelen
Function Mount-ISO {
    Param (
        [string]$isoLocalPath
    )
    $mountResult = Mount-DiskImage -ImagePath $isoLocalPath -PassThru
    $driveLetter = ($mountResult | Get-Volume).DriveLetter + ":"
    Write-Output $driveLetter
}


$driveLetter = Mount-ISO -isoLocalPath $isoLocalPath
Write-Output "ISO gekoppeld aan $driveLetter"

# Run Exchange setup commands using the call operator with updated parameters
Write-Output "Preparing Schema..."
& "$driveLetter\Setup.exe" /PrepareSchema /IAcceptExchangeServerLicenseTerms_DiagnosticDataON

Write-Output "Preparing Active Directory..."
& "$driveLetter\Setup.exe" /PrepareAD /OrganizationName:"$organizationName" /IAcceptExchangeServerLicenseTerms_DiagnosticDataON

# Since /PrepareAD with /OrganizationName prepares the organization, you can omit /PrepareOrganization
# Optionally, prepare all domains if necessary
# Write-Output "Preparing All Domains..."
# & "$driveLetter\Setup.exe" /PrepareAllDomains /IAcceptExchangeServerLicenseTerms_DiagnosticDataON

# Dismount the ISO
Write-Output "Dismounting ISO..."
Dismount-DiskImage -ImagePath $isoLocalPath


Write-Output "Exchange Server preparation completed successfully!" 
