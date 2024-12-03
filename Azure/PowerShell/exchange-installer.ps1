$isoUrl = "https://download.microsoft.com/download/b/f/7/bf7700c9-c2fd-40be-82cc-7c5330b5f981/ExchangeServer2019-x64-CU14.ISO"
$isoLocalPath = "C:\Temp\ExchangeServer.iso"

Write-Output $isoUrl

Invoke-WebRequest -Uri $isoUrl -OutFile $isoPath


# Functie om de ISO te koppelen
Function Mount-ISO {
    Param (
        [string]$isoPath
    )
    $mountResult = Mount-DiskImage -Im	agePath $isoPath -PassThru
    $driveLetter = ($mountResult | Get-Volume).DriveLetter + ":"
    Write-Output $driveLetter
}


$driveLetter = Mount-ISO -isoPath $isoLocalPath
Write-Output "ISO gekoppeld aan $driveLetter"


Start-Process -FilePath "$driveLetter\Setup.exe" -ArgumentList "/PrepareSchema", "/IAcceptExchangeServerLicenseTerms" -Wait
Start-Process -FilePath "$driveLetter\Setup.exe" -ArgumentList "/PrepareAD", "/IAcceptExchangeServerLicenseTerms" -Wait

Write-Output "Organisatie voorbereiden..."
Start-Process -FilePath "$driveLetter\Setup.exe" -ArgumentList "/PrepareOrganization", "/IAcceptExchangeServerLicenseTerms" -Wait

# Write-Output "ISO afkoppelen..."
# Dismount-DiskImage -ImagePath $isoLocalPath

# Write-Output "Configuratie voltooid!"
