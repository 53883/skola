# Create Share folder, give everyone full share permissions (ntfs will sort the permissions) #
New-Item -ItemType directory -Path C:\Shares -Force
New-SmbShare -Name "Shares$" -Path "C:\Shares"
Grant-SmbShareAccess -Name "Shares$" -AccountName "Everyone" -AccessRight Full -Force

# Create user shares #
$samAccountName = $(Get-ADUser -Filter "Name -eq 'test test'" | Select-Object -ExpandProperty SamAccountName) # make a variable here 'Name -eq 'test test'
$fullPath = "\\LAB-DC02\Shares$\{0}" -f $samAccountName
$driveLetter = "H:"
$User = Get-ADUser -Identity $samAccountName
 
if($User -ne $Null) {
    Set-ADUser $User -HomeDrive $driveLetter -HomeDirectory $fullPath -ea Stop
    $homeShare = New-Item -path $fullPath -ItemType Directory -force -ea Stop
    $acl = Get-Acl $homeShare
    $FileSystemRights = [System.Security.AccessControl.FileSystemRights]"Modify"
    $AccessControlType = [System.Security.AccessControl.AccessControlType]::Allow
    $InheritanceFlags = [System.Security.AccessControl.InheritanceFlags]"ContainerInherit, ObjectInherit"
    $PropagationFlags = [System.Security.AccessControl.PropagationFlags]"InheritOnly"
    $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule ($User.SID, $FileSystemRights, $InheritanceFlags, $PropagationFlags, $AccessControlType)
    $acl.AddAccessRule($AccessRule)
 
    Set-Acl -Path $homeShare -AclObject $acl -ea Stop
 
    Write-Host ("HomeDirectory created at {0}" -f $fullPath)
}

<# 
HÄR SKRIVER MAN VIKTIGA SAKER!

¯\_(ツ)_/¯

#>
