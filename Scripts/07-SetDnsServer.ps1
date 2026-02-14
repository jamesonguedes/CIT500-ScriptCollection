<#
.SYNOPSIS
    Configures DNS server on a network adapter.
.DESCRIPTION
    Shows available network adapters, them prompts the user for adapter name and DNS server IP adresses.
.EXAMPLE
    .\07-SetDnsServer.ps1
.NOTES
    Author: Jameson Guedes
    Created: 08 Feb 2026
#>

# ------------------------------
# Parameter Declaration
# ------------------------------
param ()

# ------------------------------
# Initialization Section
#------------------------------
$ExitCode = 0
$AdapterName = ""
$PrimaryDNS = ""
$SecondaryDNS = ""

# ------------------------------
# Main Execution Block
# ------------------------------
try {
    Write-Output "Available network adapters:"
    Get-NetAdapter | Select-Object Name, Status | Format-Table -AutoSize

    $AdapterName = Read-Host "Enter adapter name (example: Ethernet)"
    Get-NetAdapter -Name $AdapterName -ErrorAction Stop | Out-Null

    $PrimaryDNS = Read-Host "Enter primary DNS server (example: 192.168.1.10)"
    $SecondaryDNS = Read-Host "Enter secondary DNS server or press Enter to skip (optional)"

    $DnsList = @($PrimaryDNS)
    if (-not [string]::IsNullOrWhiteSpace($SecondaryDNS)) {
        $DnsList += $SecondaryDNS
    }

    Set-DnsClientServerAddress -InterfaceAlias $AdapterName -ServerAddresses $DnsList -ErrorAction Stop
    Write-Output "DNS configured on '$AdapterName': $($DnsList -join ', ')"
}

catch {
    Write-Error "DNS configuration failed: $($_.Exception.Message)"
    $ExitCode = 1
}

# ------------------------------
# Exit code handling
# ------------------------------
exit $ExitCode