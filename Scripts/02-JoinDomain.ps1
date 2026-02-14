<#
.SYNOPSIS
    Joins the local computer to an Active Directory Domain.
.DESCRIPTION
    Uses Add-Computer to join machine to an Active Directory Domain.
    Restart will be required to apply the change.
.EXAMPLE
    .\02-JoinDomain.ps1 -DomainName "ad.JG-CIT503.com"
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
    [string] $DomainName
)

# ------------------------------
# Initialization Section
#------------------------------
$ExitCode = 0

# ------------------------------
# Main Execution Block
# ------------------------------
try {
    $ComputerSystem = Get-CimInstance -ClassName Win32_ComputerSystem

    if ($ComputerSystem.PartOfDomain) {
        Write-Output "This machine is already joined to the domain '$($ComputerSystem.Domain)'. No changes were made."
    }
    else {
        $Credential = Get-Credential -Message "Enter credentials permitted to join computers to $DomainName"
        Add-Computer -DomainName $DomainName -Credential $Credential -ErrorAction Stop
        Write-Output "Join to domain '$DomainName' has been requested. Restart is required to complete the process."
    }
}
catch {
    Write-Error "Domain join failed: $($_.Exception.Message)"
    $ExitCode = 1
}

# ------------------------------
# Exit code handling
# ------------------------------
return $ExitCode