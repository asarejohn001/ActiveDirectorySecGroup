<#
Author: John Asare
Date: 7/30/24

Description: Use below code to manage security group on active direocty
#>

# Import the Active Directory module
Import-Module ActiveDirectory

# Define the group name
$groupName = "Enter the group name"

# Define the path to the CSV file
$members = "enter path to the csv file"

# Define the remote computer and credentials
$remoteComputer = "RemoteADComputerName"
$credential = Get-Credential

# Create a new PSSession
$session = New-PSSession -ComputerName $remoteComputer -Credential $credential

# Invoke the script block on the remote machine
Invoke-Command -Session $session -ScriptBlock $scriptBlock -ArgumentList "ClearPoint Test", $remoteCsvPath

# Get emails of the CSV file, use the email to retrieve the distinName from AD, and then add member to the sec group
Import-Csv -Path $members | ForEach-Object {
    $email = $_.members
    try {
        $user = Get-ADUser -Filter "EmailAddress -eq '$email'"
        if ($user) {
            Add-ADGroupMember -Identity $groupName -Members $user.DistinguishedName -ErrorAction Stop
            Write-Host "Successfully added $email to $groupName"
        } else {
            Write-Host "User with email $email not found in Active Directory."
        }
    } catch {
        Write-Host "Failed to add $email to $groupName. Error: $_"
    }
}


# Read the SamAccount from the CSV file and remove each member from the group
Import-Csv -Path $membersToRemove | ForEach-Object {
    $samAccountName = $_.samAccountName
    try {
        Remove-ADGroupMember -Identity $groupName -Members $samAccountName -Confirm:$false -ErrorAction Stop
        Write-Host "Successfully removed $samAccountName from $groupName"
    } catch {
        Write-Host "Failed to remove $samAccountName from $groupName. Error: $_"
    }
}

# Disconnect the session
Remove-PSSession -Session $session

