$credentials = Get-Credential

Invoke-Command -ComputerName "10.0.0.10" -ScriptBlock {

    $OUhash = [ordered]@{
        "LAB"       = "DC=lab,DC=local"
        "Users"     = "OU=LAB,DC=lab,DC=local"
        "Stockholm" = "OU=Users,OU=LAB,DC=lab,DC=local"
        "Arjeplog"  = "OU=Users,OU=LAB,DC=lab,DC=local"
        "Groups"    = "OU=LAB,DC=lab,DC=local"
        "Servers"   = "OU=LAB,DC=lab,DC=local"
        "Computers" = "OU=LAB,DC=lab,DC=local"
    }

    foreach ($OU in $OUhash.Keys) {
        [string] $Path = "OU=$OU,$($OUhash.item($ou))"
        if (!([adsi]::Exists("LDAP://$Path"))) {
            New-ADOrganizationalUnit -Name "$OU" -Path $OUhash.Item($ou) # -path här är ju tex "OU=LAB,DC=lab,DC=local"
        }
    }
} -credential $credentials


<# 
HÄR SKRIVER MAN VIKTIGA SAKER!

¯\_(ツ)_/¯

#>
