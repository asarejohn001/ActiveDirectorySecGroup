<#
Author: John Asare
Date: 7/30/24

Description: Use below code to manage security group on active direocty
#>

# Fucntion to log output
function Get-Log {
    param (
        [string]$LogFilePath,
        [string]$LogMessage
    )

    # Create the log entry with the current date and time
    $logEntry = "{0} - {1}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss"), $LogMessage

    # Append the log entry to the log file
    Add-Content -Path $LogFilePath -Value $logEntry
}

# Define the log file path
$logFilePath = "enter log file path"

# Install Active Directory module, if not already installed
Install-Module ActiveDirectory # not needed if machine have RSAT installed

# Import the Active Directory module
Import-Module ActiveDirectory

# Define the group name
$groupName = "enter group name"

# Define the path to the CSV file
$members = "enter csv file"

# Define the remote computer and credentials
$remoteComputer = "enter domain name" # not needed if running script from a computer on the domain
$credential = Get-Credential # not needed if running script from a computer on the domain

# Create a new PSSession
$session = New-PSSession -ComputerName $remoteComputer -Credential $credential # not needed if running script from a computer on the domain

# Invoke the script block on the remote machine
Invoke-Command -Session $session # not needed if running script from a computer on the domain

# Read the SamAccount from the CSV file and remove each member from the group
Import-Csv -Path $members | ForEach-Object {
    $samAccountName = $_.SamAccountName
    try {
        Remove-ADGroupMember -Identity $groupName -Members $samAccountName -Confirm:$false -ErrorAction Stop
        Get-Log -LogFilePath $logFilePath -LogMessage "Successfully removed $samAccountName from $groupName"
        Write-Host "Successfully removed users, check log file"
    } catch {
        Get-Log -LogMessage "Failed to remove $samAccountName from $groupName. Error: $_" -LogFilePath $logFilePath
        Write-Host "Failed to removed users"
    }
}

# Disconnect the session
Remove-PSSession -Session $session
