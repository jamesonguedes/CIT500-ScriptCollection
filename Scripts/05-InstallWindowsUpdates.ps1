<#
.SYNOPSIS
    Installs all Windows updates.
.DESCRIPTION
    Uses PSWindowsUpdate module to download and install all available updates.
    Restart may be required to complete installation.
.EXAMPLE
    .\02-InstallWindowsUpdates.ps1
.NOTES
    Author: Jameson Guedes
    Created: 08 Feb 2026
    Requirements: Run PowerShell as Administrator to install updates.
    Troubleshooting: Windows Security may block PowerShell. Allow pwsh.exe through Controlled folder access.
#>

# ------------------------------
# Parameter Declaration
# ------------------------------
param ()

# ------------------------------
# Initialization Section
#------------------------------
$ExitCode = 0

# ------------------------------
# Main Execution Block
# ------------------------------
try {
    # Ensure PSWindowsUpdate module is available
    if(-not(Get-Module -ListAvailable -Name PSWindowsUpdate)) {
        #Trust PSGallery and install module
        Set-PSRepository -Name PSGallery -InstallationPolicy Trusted -ErrorAction Stop
        #Install for current user
        Install-Module -Name PSWindowsUpdate -Scope CurrentUser -Force -Confirm:$false -ErrorAction Stop
    }
    # Load the module commands:
    Import-Module PSWindowsUpdate -ErrorAction Stop
    # Download and install all available updates
    # -IgnoreReboot is added to aviod automaticaly reboot the machine
    Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -IgnoreReboot -ErrorAction Stop
    Write-Output "Windows Updates have been installed. A restart may be required to complete installation."
}
catch {
    Write-Error "Windows Updates installation failed: $($_.Exception.Message)"
    $ExitCode = 1
}

# ------------------------------
# Exit code handling
# ------------------------------
exit $ExitCode