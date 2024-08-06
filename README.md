# Active Directory Security Group

Active Directory security groups can provide an efficient way to assign access to resources on your network. 

## Add Users to an Active Directory Security Group
Using the [addMemberToSecGrp.ps1](addMemberToSecGrp.ps1), you can add multiple users to an active directory sercurity group. The script will
1. Retrieve an user's email address from a provided CSV
2. It will then use the email address to find the [SamAccountName](https://learn.microsoft.com/en-us/windows/win32/ad/naming-properties#samaccountname) from Active Directory
3. Use the [Add-ADGroupMember](https://learn.microsoft.com/en-us/powershell/module/activedirectory/add-adgroupmember?view=windowsserver2022-ps) to add the SamAccount to the specified group

> [!IMPORTANT]  
> Make sure to edit the script to fit your need. 

### Remove Users from an Active Directory Security Group
Using the [removeMemberFromScGrp.ps1](removeMemberFromScGrp.ps1), you can remove multiple users from an [active directory security group](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/understand-security-groups). The script will:
1. Retrieve user email address from CSV
2. Use the email address to search through Active Directory for the [SamAccountName](https://learn.microsoft.com/en-us/windows/win32/ad/naming-properties#samaccountname) associated with the email address
3. Check if the SamAccountName exist
4. Use [Remove-ADGroupMember](https://learn.microsoft.com/en-us/powershell/module/activedirectory/remove-adgroupmember?view=windowsserver2022-ps) to remove the SamAccountName from the Active Directory security group