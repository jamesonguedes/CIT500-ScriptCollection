<#
.SYNOPSIS
    Sets regional settings on the local machine.
.DESCRIPTION
    Promts the user for Culture, System Locale, and Home Location (GeoId), then applies them.
.EXAMPLE
    .\04-SetRegionalSettings.ps1
.NOTES
    Author: Jameson Guedes
    Created: 08 Feb 2026
#>

# ------------------------------
# Parameter Declaration
# ------------------------------
param (
    
)

# ------------------------------
# Initialization Section
#------------------------------
$ErrorActionPreference = 'Stop'
$ExitCode = 0
$Culture = ""
$SystemLocale = ""
$GeoId = ""

# ------------------------------
# Main Execution Block
# ------------------------------
try {
    Write-Host "Please, enter the regional settings you want to apply."
    Write-Host ""
    $Culture = Read-Host "Enter Culture (example: en-NZ)"
    $SystemLocale = Read-Host "Enter System Locale (example: en-NZ)"
    $GeoId = Read-Host "Enter Home Location GeoId (example: 183)"

    Set-Culture -CultureInfo $Culture
    Set-WinSystemLocale -SystemLocale $SystemLocale
    Set-WinHomeLocation -GeoId ([int]$GeoId)

    #Displays current settings
    Write-Host ""
    Write-Host "Done. Current settings:"
    Write-Host "Culture:"
    Get-Culture
    Write-Host "System Locale:"
    Get-WinSystemLocale
    Write-Host "Home Location:"
    Get-WinHomeLocation

    $ExitCode = 0
}
catch {
    Write-Error "Regional settings configuration failed: $($_.Exception.Message)"
    $ExitCode = 1
}

# ------------------------------
# Exit code handling
# ------------------------------
exit $ExitCode