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

$name = Read-Host -Prompt "F\ör- och efternamn: "
while ($name.Split(" ").Length -lt 2 -or $name.Split(" ").Length -gt 3) {
    Write-Output "Felaktig input."
    $name = Read-Host -Prompt "F\ör- och efternamn: "
}
if ($name.Split(" ").Length -gt 2) {

}
$firstname = $name.Split(" ")[0]
$lastname = $name.Split(" ")[1]
$username = (Remove-StringLatinCharacters -String ($firstname.Substring(0,3).ToLower() + $lastname.Substring(0,3).ToLower()))
$password = [System.Web.Security.Membership]::GeneratePassword(10,0) | ConvertTo-SecureString -AsPlainText -Force
$email = (Remove-StringLatinCharacters -String "$($name.Replace(" ", ".").ToLower())@$($company)")
$phonenr = Read-Host -Prompt "Telefonnummer tack: "
$location = Get-ADOrganizationalUnit -LDAPFilter "(name=*)" -SearchBase "OU=Users,OU=test,DC=test,DC=local" -SearchScope OneLevel -Server $adip -Credential $credentials | Select -Property "Name", "DistinguishedName" | Out-GridView -PassThru

<# while (Get-ADUser -Identity $username -Server $adip -Credential $credentials) {
    Write-Output "Användare med det användarnamet finns redan."
    $counter += 1
    $username = "$username + $counter"
} #>

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
