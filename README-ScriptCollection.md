# Task 2 - Script Collection (L04)

## Overview
This script collection was developed as part of the *Yoobee Colleges CIT500 assessment* to automate common workstation configuration tasks in a *Managed Service Provider (MSP)* environment.
The purpose of this collection is to improve efficiency, consistency, by reducing human error when configuring new Windows workstations. The scripts automate key system administration tasks including adding computer nae, joining domain, set regional configuration, network setup, DNS configuration, and get Windows updates.
All scripts are executed in a structured and controlled order using the master runner file: '00-RunAll.cmd'.

## Project Structure

The script collection is organied in the folder as follows:

ScriptCollection/
|
|-- 00-RunAll.cmd
|-- README-ScriptCollection.md
\-- Scripts
    |-- 01-RenameComputer.ps1
    |-- 02-JoinDomain.ps1
    |-- 03-SetTimeZone.ps1
    |-- 04-SetRegion.ps1
    |-- 05-InstallWindowsUpdates.ps1
    |-- 06-ConfigNetwork.ps1
    \-- 07-SetDnsServer.ps1

'00-RunAll.cmd'- Master file that executes all critps in the recommended order.
'Scripts/' - Contains the individuals PowerShell scripts that runs a specifica configuration task.
'README-ScriptCollection.md' - Provides documentation, usage instructions, and troubleshooting guidance.

## Usage Instructions

### Requirements
- Windows 10 or 11 Pro
- Powershell 5 or 7
- Administration privileges
- Network connectivity for domain join and updates
- Access to the Active Directory domain

### How to run the Script Collection
1. Navigate to the folder 'ScriptCollection'.
2. Right-click on the file '00-RunAll.cmd'
3. Choose the option "Run as Administrator" for priviledge access.
4. Follow the prompts displayed and input the values for each step.
5. Restart machine for fully apply changes.

### Execution Order
The scripts will run in the following order to ensure handling dependency properly:
1. Rename Computer
2. Set Time Zone
3. Configure Regional Settings
4. Configure Network (IP/SubnetMask/Gateway)
5. Configure DNS
6. Join Domain
7. Install Windows Updates

## Script Descriptions

### 01-Rename Computer.ps1
**Purpose**
Renames the local computer according to organisational naming standards.
**Functionality:**
- Prompts the user to enter a computer name.
- Checks if the computer is already named with the inpput name.
- Renames the computer if required.
- Restart will be required for taking effect.
---

### 02-JoinDomain.ps1
**Purpose**
Joins the computer to an Active Directory domain.
**Functionality:**
- Checks if the computer is already part of a domain.
- Prompts the user for domain credentials.
- Requests to join domain.
- A restart will be required for taking effect.
---

### 03-SetTimeZone.ps1
**Purpose**
Configures the system time zone.
**Functionality:**
- Displays the current time zone.
- Prompts the user to enter a valid Windows time zone ID.
- Applies the selected time zone.
---

### 04-SetRegion.ps1
**Purpose**
JConfigures regional and localisation settings.
**Functionality:**
- Prompts the user for culture, system locale, and GeoId.
- Applies regional settings.
- Displays updated configuration for verification.
---

### 05-InstallWindowsUpdates.ps1
**Purpose**
Installs available Windows Updates.
**Functionality:**
- Searches for the available Windows updates.
- Installs updates automatically.
- Restart ay be required to complete updates.
---

### 06-ConfigNetwork.ps1
**Purpose**
Configures static IPv4 network settings.
**Functionality:**
- Displays the current IPv4 configuration.
- Prompts user for adapter name, IP address, prefix length, and default gateway.
- Removes existings IPv4 addresses and default route to prevent conflicts.
- Applies new static configuration.
- Displays the  updated network configuration.
---

### 07-SetDnsServer.ps1
**Purpose**
Configures DNS server addresses on the selected network adapter.
**Functionality:**
- Displays available network adapters.
- Prompts user for primary and secondary DNS servers.
- Applies DNS settings.
---

## Troubleshooting

### Script Stops During Execution
> If the script collection stops unexpectedly:
    - Review the last message displayed in the Command Prompt window.
    - Ensure user is running script as Administrator.
    - Check if the imputs are correct.
---

### Domain Join Fails
> Possible causes:
    - Incorrect domain name.
    - DNS server might not be pointing to the Domain Controller,
    - Inout of incorrect credentials.
    - No network connectivity.
> Recommendations:
    - Run 'ipconfig /all' and verify DNS settings,
    - Ensure the domain controller is reachable using 'ping'.
    - Confirm credetials have right permission level to join worksatation to the domain.
---

### Network Configuration Errors
> If displays error "DefaultGateway already exists" occurs:
    - The script removes existing routes and IP addresses before applying new configuration.
    - Ensure the correct adapter name is selected.
    - Confirm the IP address is not already in use on the network.
---

### Windows Updates Do Not Install
> Recommendations:
    - Verify internet connectivity.
    - Ensure Windows Update service are running.
    - Restart the machine and rerun the script collection.
---

## Conclusion
This script collection demonstrates the ability to develop, organise, and document automation tools for systems administration.
Documentation includes clear guidance for usage and troubleshooting.
The collections improves system administration efficiency, reduces manual configuration errors, and aligns with best practices in IT automationand documentation.