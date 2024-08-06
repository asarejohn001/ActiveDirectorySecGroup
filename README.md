# Active Directory Security Group

Active Directory security groups can provide an efficient way to assign access to resources on your network. 

## Add Users to an Active Directory Security Group
Using the [addMemberToSecGrp.ps1](addMemberToSecGrp.ps1), you can add multiple users to an active directory sercurity group. The script will
1. Retrieve an user's email address from a provided CSV
2. It will then use the email address to find the [SamAccountName](https://learn.microsoft.com/en-us/windows/win32/ad/naming-properties#samaccountname) from Active Directory
3. Use the [Add-ADGroupMember](https://learn.microsoft.com/en-us/powershell/module/activedirectory/add-adgroupmember?view=windowsserver2022-ps) to add the SamAccount to the specified group

> [!IMPORTANT]  
> Make sure to edit the script to fit your need. 

