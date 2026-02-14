<#
.SYNOPSIS
    Renames the local computer.
.DESCRIPTION
    Uses Rename-Computer to rename the machine.
    Restart will be required to apply the change.
.EXAMPLE
    .\01-RenameComputer.ps1 -ComputerName "JG-VMWS1"
.NOTES
    Author: Jameson Guedes
    Created: 08 Feb 2026
#>

# ------------------------------
# Parameter Declaration
# ------------------------------
param (
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(5,15)]
    [string] $ComputerName
)

# ------------------------------
# Initialization Section
#------------------------------
$ExitCode = 0
$CurrentName = $env:COMPUTERNAME

# ------------------------------
# Main Execution Block
# ------------------------------
try {
    if ($CurrentName -ieq $ComputerName) {
        Write-Output "This machine name is already set as '$ComputerName'. No changes were made."
    }
    else {
        Rename-Computer -NewName $ComputerName -Force -ErrorAction Stop
        Write-Output "Rename requested. Restart is required to complete the process."
    }
}
catch {
    Write-Error "Rename failed: $($_.Exception.Message)"
    $ExitCode = 1
}

# ------------------------------
# Exit code handling
# ------------------------------
exit $ExitCode