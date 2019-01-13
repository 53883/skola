#region company variables
$adip = "192.168.1.206"
$company = "test.local"
#$credentials = Get-Credential
#endregion

#region functions
function Remove-StringLatinCharacters
{
    PARAM ([string]$String)
    [Text.Encoding]::ASCII.GetString([Text.Encoding]::GetEncoding("Cyrillic").GetBytes($String))
}
#endregion

# Skapa en användare

$name = Read-Host -Prompt "First and lastname: "
while ($name.Split(" ").Length -lt 2 -or $name.Split(" ").Length -gt 3) {
    Write-Output "Invalid input"
    $name = Read-Host -Prompt "First and lastname: "
}
if ($name.Split(" ").Length -gt 2) {

}
$firstname = $name.Split(" ")[0]
$lastname = $name.Split(" ")[1]
$username = (Remove-StringLatinCharacters -String ($firstname.Substring(0,3).ToLower() + $lastname.Substring(0,3).ToLower()))
$password = [System.Web.Security.Membership]::GeneratePassword(10,0) | ConvertTo-SecureString -AsPlainText -Force
$email = (Remove-StringLatinCharacters -String "$($name.Replace(" ", ".").ToLower())@$($company)")
$phonenr = Read-Host -Prompt "Phone number: "
$location = Get-ADOrganizationalUnit -LDAPFilter "(name=*)" -SearchBase "OU=Users,OU=test,DC=test,DC=local" -SearchScope OneLevel -Server $adip -Credential $credentials | Select -Property "Name", "DistinguishedName" | Out-GridView -PassThru
$counter = 0
while ((Get-ADUser -Filter "sAMAccountName -eq '$($username)'" -Server $adip -Credential $credentials)) {
    Write-Output "User already exists"
    $counter += 1
    $username = "$username$counter"
}
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
