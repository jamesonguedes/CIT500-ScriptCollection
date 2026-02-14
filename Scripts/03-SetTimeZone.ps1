<#
.SYNOPSIS
    Sets time zone for the local machine.
.DESCRIPTION
    Displays current time zone, and asks for new time zone to set.
    Restart is not required.
.EXAMPLE
    .\02-SetTimeZone.ps1
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
$CurrentTimeZone = (Get-TimeZone).Id
$NewTimeZone = ""

# ------------------------------
# Main Execution Block
# ------------------------------
try {
    # Shows current time zone
    Write-Output "The current time zone is: $CurrentTimeZone"

    # Asks input for new time zone
    $NewTimeZone = Read-Host "Please, write new time zone (example: New Zealand Standard Time):"

    #Apply changes
    Set-Timezone -Id $NewTimeZone -ErrorAction Stop
    $CurrentTimeZone = (Get-TimeZone).Id
    Write-Output "Changes have been made. The current time zone is: $CurrentTimeZone"
}

catch {
    Write-Error "Time zone configuration failed: $($_.Exception.Message)"
    $ExitCode = 1
}

# ------------------------------
# Exit code handling
# ------------------------------
exit $ExitCode