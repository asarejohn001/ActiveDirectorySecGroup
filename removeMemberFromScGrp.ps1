<#
Author: John Asare
Date: 7/30/24

Description: Use below code to manage security group on active direocty
#>

# Install Active Directory module, if not already installed
Install-Module ActiveDirectory # not needed if machine have RSAT installed

# Import the Active Directory module
Import-Module ActiveDirectory

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

# Get emails from csv and use to retrive SamAccountName to remove from the security group
Write-Host "Script In-progress..."
Import-Csv -Path $members | ForEach-Object {
    $email = $_.members
    try {
        $user = Get-ADUser -Filter "EmailAddress -eq '$email'"
        if ($user) {
            Remove-ADGroupMember -Identity $groupName -Members $user.SamAccountName -Confirm:$false -ErrorAction Stop
            Get-Log -LogFilePath $logFilePath -LogMessage "Successfully removed $($user.SamAccountName) from $groupName"
        } else {
            Get-Log -LogFilePath $logFilePath -LogMessage "User with email $email not found in Active Directory."
        }
    } catch {
        Get-Log -LogFilePath $logFilePath -LogMessage "Failed to remove $($user.SamAccountName) from $groupName. Error: $_"
    }
}

# Signal when code is done running
Write-Host "Script is done running. Check the log file for results"

# Disconnect the session
Remove-PSSession -Session $session
