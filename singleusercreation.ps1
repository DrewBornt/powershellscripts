# Collect User Information
$fullname = Read-Host "Enter First and Last name?"
$password = Read-Host "Password?" -AsSecureString
$firstname, $lastname = $fullname.Split(' ')
$username = $fullname.Replace(' ','')
$groups = Read-Host "What groups to assign them to?"
$groups = $groups.Split(' ')

Import-Module ActiveDirectory

# Create User
New-ADUser -Name $fullname `
-DisplayName $fullname `
-GivenName $firstname `
-Surname $lastname `
-EmailAddress "$username@home.local" `
-SamAccountName $username `
-Path "OU=_Domain Users, DC=HOME, DC=LOCAL" `
-Enabled $True `
-ChangePasswordAtLogon $True `
-UserPrincipalName "$username@home.local" `
-AccountPassword $password

Foreach ($group in $groups)
{
    Add-ADGroupMember `
    -Identity $group `
    -Members $username
}


# Create User Shares and Files

New-Item `
-ItemType "directory" `
-Path "\\FileShare01\c`$\Shares\$username"

New-Item `
-ItemType "directory" `
-Path "\\FileShare01\c`$\Shares\Scans\$username"

New-SmbShare -Name "$username" -CimSession FileShare01 -Path "c:\Shares\$username"




# Assign License (TO COME)