# Parameters for Domain Join
$DomainName = "draak-hosting.nl"  # Replace with your domain name
$DomainUser = "draak-hosting\knaakadmin"  # Replace with a domain user with join privileges
$DomainPassword = "Knaakhosting4.2!"  # Replace with the user's password
$RestartAfterJoin = $true  # Set to $true to automatically restart the server after joining

# Convert password to a secure string
$SecurePassword = ConvertTo-SecureString -String $DomainPassword -AsPlainText -Force

# Create a PSCredential object
$DomainCredential = New-Object System.Management.Automation.PSCredential($DomainUser, $SecurePassword)

# Join the server to the domain
try {
    Add-Computer -DomainName $DomainName -Credential $DomainCredential -Force
    Write-Output "Server successfully joined to the domain '$DomainName'."
    
    # Restart the server if required
    if ($RestartAfterJoin) {
        Write-Output "Restarting the server..."
        Restart-Computer -Force
    }
} catch {
    Write-Error "Failed to join the domain. Error: $_"
}