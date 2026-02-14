<#
.SYNOPSIS
    Configures network settings on network adapter.
.DESCRIPTION
    Displays current IPv4 configuration, then prompts the user to enter new configuration values.
    Restart is not required.
.EXAMPLE
    .\06-ConfigNetwork.ps1
.NOTES
    Author: Jameson Guedes
    Created: 10 Feb 2026
#>

# ------------------------------
# Parameter Declaration
# ------------------------------
param ()

# ------------------------------
# Initialization Section
#------------------------------
$ExitCode = 0
# Variables to be filled by user input
$AdapterName = ""
$IPv4Address = ""
$PrefixLength = 0
$DefaultGateway = ""

# ------------------------------
# Main Execution Block
# ------------------------------
try {
    # Displays the current IPv4 configuration before changes
    Write-Output ""
    Write-Output "Current network configuration (IPv4):"
    Get-NetIPConfiguration | ForEach-Object {
        Write-Output "$($_.InterfaceAlias) - IP: $($_.IPv4Address.IPAddress) - GW: $($_.IPv4DefaultGateway.NextHop) - DNS: $($_.DNSServer.ServerAddress)"
    }

    # Displays the available adapters
    Write-Output ""
    Write-Output "Choose the network adapter to configure:"
    Get-NetAdapter | Select-Object Name, Status | Format-Table -AutoSize

    # Input of adapter name
    $AdapterName = Read-Host "Enter adapter name (example: Ethernet)"
    Get-NetAdapter -Name $AdapterName -ErrorAction Stop | Out-Null

    # Input for IPv4 settings
    Write-Output ""
    Write-Output "Enter the new IPv4 settings"
    $IPv4Address = Read-Host "Enter IPv4 address (example: 192.168.1.50)"

    # This section is included is a reminder for the PrefixLength.
    Write-Output "" 
    Write-Output "Subnet Mask prefix equivalents:"
    Write-Output "      255.0.0.0 = 8"
    Write-Output "    255.255.0.0 = 16"
    Write-Output "  255.255.255.0 = 24"
    Write-Output "255.255.255.128 = 25"
    Write-Output "255.255.255.192 = 26"
    Write-Output "255.255.255.224 = 27"
    Write-Output "255.255.255.240 = 28"
    Write-Output "255.255.255.248 = 29"
    Write-Output "255.255.255.252 = 30"
    Write-Output ""

    $PrefixLength = [int](Read-Host "Enter subnet prefix length (example: 24)")
    $DefaultGateway = Read-Host "Enter default gateway (example: 192.168.1.1)"

    # COnfirmation before applying the changes
    Write-Output ""
    Write-Output "You entered: Adapter='$AdapterName'  IP='$IPv4Address/$PrefixLength'  Gateway='$DefaultGateway'"
    $Confirm = Read-Host "Please, type Y to apply changes, or press Enter to cancel"

    # Here either y or Y will be accepted for confirmation
    if ($Confirm -notmatch '^(?i)y$') {
        Write-Output "Cancelled. No changes were made."
        $ExitCode = 0
        throw "User cancelled"
    }

    # Remove the existing default gateway to avoid "DefaultGateway already exists" error
    Get-NetRoute -InterfaceAlias $AdapterName -AddressFamily IPv4 -ErrorAction SilentlyContinue | Where-Object { $_.DestinationPrefix -eq "0.0.0.0/0" } | ForEach-Object {
        Remove-NetRoute -InterfaceAlias $AdapterName -DestinationPrefix $_.DestinationPrefix -NextHop $_.NextHop -Confirm:$false -ErrorAction SilentlyContinue
    }

    # Removes any existing IPv4 addresses
    Get-NetIPAddress -InterfaceAlias $AdapterName -AddressFamily IPv4 -ErrorAction SilentlyContinue | Remove-NetIPAddress -Confirm:$false -ErrorAction SilentlyContinue

    Write-Output ""
    Write-Output "Applying configuration as follows:"
    New-NetIPAddress -InterfaceAlias $AdapterName -IPAddress $IPv4Address -PrefixLength $PrefixLength -DefaultGateway $DefaultGateway -ErrorAction Stop

    Write-Output "Configuration has been completed. '$AdapterName' configured with IP $IPv4Address/$PrefixLength and gateway $DefaultGateway."

    # Displays the configuration after applying changes
    Write-Output ""
    Write-Output "Current network configuration (IPv4):"
    Get-NetIPConfiguration | ForEach-Object {
        Write-Output "$($_.InterfaceAlias) - IP: $($_.IPv4Address.IPAddress) - GW: $($_.IPv4DefaultGateway.NextHop) - DNS: $($_.DNSServer.ServerAddress)"
    }
}
catch {
    if ($_.Exception.Message -eq "User cancelled") {
        $ExitCode = 0
    }
    else {
        Write-Error "Network configuration failed: $($_.Exception.Message)"
        $ExitCode = 1
    }
    
}

# ------------------------------
# Exit code handling
# ------------------------------
return $ExitCode