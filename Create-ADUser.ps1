#region COMPANY VARIABLES

# IP to AD-Server
$adip = "192.168.1.206"

# Domain 
$company = "test.local"

# The OU where the users are
$ou = "OU=Users,OU=test,DC=test,DC=local"

#$credentials = Get-Credential
#endregion

#region FUNCTIONS
# Removes specialcharacters
function Remove-StringLatinCharacters
{
    PARAM ([string]$String)
    [Text.Encoding]::ASCII.GetString([Text.Encoding]::GetEncoding("Cyrillic").GetBytes($String))
}
#endregion

#region VARIABLES
$name = Read-Host -Prompt "First and lastname: "
while ($name.Split(" ").Length -ne 2) {
    Write-Output "Invalid input"
    $name = Read-Host -Prompt "First and lastname: "
}

$firstname = $name.Split(" ")[0]
$lastname = $name.Split(" ")[1]
$username = (Remove-StringLatinCharacters -String ($firstname.Substring(0,3).ToLower() + $lastname.Substring(0,3).ToLower()))
$password = [System.Web.Security.Membership]::GeneratePassword(10,0) | ConvertTo-SecureString -AsPlainText -Force
$email = (Remove-StringLatinCharacters -String "$($name.Replace(" ", ".").ToLower())@$($company)")
$phonenr = Read-Host -Prompt "Phone number: "
$location = Get-ADOrganizationalUnit -LDAPFilter "(name=*)" -SearchBase $ou -SearchScope OneLevel -Server $adip -Credential $credentials | Select-Object -Property "Name", "DistinguishedName" | Out-GridView -PassThru
$counter = 0

# Check if sAMAccountName already exists
# Note to self, check userprinciplename?
while ((Get-ADUser -Filter "sAMAccountName -eq '$($username)'" -Server $adip -Credential $credentials)) {
    Write-Output "User already exists"
    $counter += 1
    $username = "$username$counter"
}
#endregion

#region CREATE USER
New-ADUser -Name $name `
     -SamAccountName $username `
     -DisplayName $name `
     -UserPrincipalName "$username@$company" `
     -GivenName $firstname `
     -Surname $lastname `
     -AccountPassword $password `
     -MobilePhone $phonenr `
     -EmailAddress $email `
     -Path $location.DistinguishedName `
     -ChangePasswordAtLogon $true `
     -Enabled $true `
     -Server $adip `
-Credential $credentials
#endregion

#region output to user
Write-Host "Your User is created: `n Name: $name `n Email: $email `n Login: $username `n Password: $password"
#endregion
