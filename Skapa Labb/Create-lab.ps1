### START - AREA TO EDIT ###

# not there yet, will fix this

### STOP - AREA TO EDIT ###
$WarningPreference = "SilentlyContinue"
function Write-Step {
    param (
        [string]$String,
        [switch]$Complete
    )
    if ($Complete) {Write-Host "OK" -ForegroundColor "Green"}
    else {
        $String += ":"
        while ($String.Length -lt 100) {
            $String += " "
        }
        Write-Host $String -NoNewline
    }
}

### START EDITING HERE, FOR YOUR PREFERENCES ###

$vcpu = 2
$memory = 4GB
$DefaultGW = "10.0.0.1"
$DNSServer = "10.0.0.10"
$DNSDomain = "lab.local"
$SwitchNameDomain = "Lab-Switch"
$NetworkAdapterName = "Public"
$domainAdminAccount = "LAB\Administrator"
$AdminAccount = "Administrator"
$AdminPassword = "Linux4Ever"
$Organization = "Lab"
$ProductID = "XXXXX-XXXXX-XXXXX-XXXXX-XXXXX" # ENTER YOUR PRODUCTKEY HERE
### MAKE SURE your Hyper-V global settings are set to E:\Hyper-V\PROD\ do not forget the last "\" (you can change to w/e but do it here also and include the last "\" )
$Path = Hyper-V\Get-VMHost | Select-Object VirtualMachinePath -ExpandProperty VirtualMachinePath
$StartupFolder = "E:\Hyper-V\PROD\"
$TemplateLocation = "E:\Hyper-V\PROD\LAB-TEMPLATE.vhdx"
$UnattendLocation = "E:\Hyper-V\PROD\unattend.xml"

### STOP EDITING HERE, FOR YOUR PREFERENCES ###

$credentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $AdminAccount, ($AdminPassword | ConvertTo-SecureString -AsPlainText -Force)
$domainCredentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $domainAdminAccount, ($AdminPassword | ConvertTo-SecureString -AsPlainText -Force)

### START EDIT IP-ADDRESSES ONLY ###
### AT THIS POINT, YOU CAN NOT EDIT VM-NAMES ###

$VMs = [ordered]@{
    "LAB-DC01"  = "10.0.0.10"
    "LAB-DC02"  = "10.0.0.11"
    "LAB-SRV01" = "10.0.0.12"
    "LAB-FILE01" = "10.0.0.13"
}
### STOP EDIT IP-ADDRESSES ONLY ###

foreach ($Name in $VMS.Keys) {
    
    $IPDomain = $VMs.Item($Name)
    $VHDPath = $Path + $Name + "\" + $Name + ".vhdx"

    $VMExists = Get-VM $Name
    if ($VMExists) {
        Write-Output "VM $Name already exists"
        continue
    }
    
    Write-Step "Creating VM $Name" ### Create the VM
    New-VM -Name $Name -Path $Path  -MemoryStartupBytes $memory  -Generation 2 -NoVHD
    Write-Step -Complete
 
    Write-Step "Replacing NIC" ### Remove any auto generated adapters and add new ones with correct names for Consistent Device Naming
    Get-VMNetworkAdapter -VMName $Name | Remove-VMNetworkAdapter
    Add-VMNetworkAdapter -VMName $Name -SwitchName $SwitchNameDomain -Name $NetworkAdapterName -DeviceNaming On
    Write-Step -Complete
 
    Write-Step "Setting static MAC-address" ### Start and stop VM to get mac address, then arm the new MAC address on the NIC itself
    Start-VM $Name
    Start-Sleep 5
    Stop-VM $Name -Force
    Start-Sleep 5
    $MACAddress = Get-VMNetworkAdapter -VMName $Name -Name $NetworkAdapterName | Select-Object MacAddress -ExpandProperty MacAddress
    $MACAddress = ($MACAddress -replace '(..)', '$1-').Trim('-')
    Get-VMNetworkAdapter -VMName $Name -Name $NetworkAdapterName | Set-VMNetworkAdapter -StaticMacAddress $MACAddress
    Write-Step -Complete
 
    Write-Step "Copying template" ### Copy the template and add the disk on the VM. Also configure CPU and start - stop settings
    Copy-item $TemplateLocation -Destination  $VHDPath
    Write-Step -Complete
    Set-VM -Name $Name -ProcessorCount $vcpu  -AutomaticStartAction Start -AutomaticStopAction ShutDown -AutomaticStartDelay 5 
    Write-Step "Adding template VHD to VM" ### Adding template VHD to VM
    Add-VMHardDiskDrive -VMName $Name -ControllerType SCSI -Path $VHDPath
    Write-Step -Complete

    Write-Step "Setting template VHD as boot device" ### Set first boot device to the disk we attached
    $Drive = Get-VMHardDiskDrive -VMName $Name | Where-Object {$_.Path -eq "$VHDPath"}
    Get-VMFirmware -VMName $Name | Set-VMFirmware -FirstBootDevice $Drive
    Write-Step -Complete
 
    Write-Step "Generating unattend.xml for VM" ### Rename values in the xml unattendfile
    Copy-Item $UnattendLocation $StartupFolder\"unattend"$Name".xml"
    $DefaultXML = $StartupFolder + "\unattend" + $Name + ".xml"
    $NewXML = $StartupFolder + "\unattend$Name.xml"
    $DefaultXML = Get-Content $DefaultXML
    $DefaultXML  | Foreach-Object {
        $_ -replace '1AdminAccount', $AdminAccount `
            -replace '1Organization', $Organization `
            -replace '1Name', $Name `
            -replace '1ProductID', $ProductID`
            -replace '1MacAddressDomain', $MACAddress `
            -replace '1DefaultGW', $DefaultGW `
            -replace '1DNSServer', $DNSServer `
            -replace '1DNSDomain', $DNSDomain `
            -replace '1AdminPassword', $AdminPassword `
            -replace '1IPDomain', $IPDomain `
    } | Set-Content $NewXML
    Write-Step -Complete
 
    Write-Step "Adding unattend.xml to VHD" ### Adding unattend.xml to VHD
    Mount-VHD -Path $VHDPath
    $VolumeDriveLetter = Get-DiskImage $VHDPath | Get-Disk | Get-Partition | Get-Volume | Where-Object {$_.FileSystemLabel -ne "Recovery"} | Select-Object DriveLetter -ExpandProperty DriveLetter
    $DriveLetter = "$VolumeDriveLetter" + ":"
    Copy-Item $NewXML $DriveLetter\unattend.xml
    Dismount-VHD -Path $VHDPath
    Write-Step -Complete
    Write-Step "Starting VM" ### Starting VM
    Start-VM $Name
    Start-Sleep -Seconds 100
    Write-Step -Complete

    switch ($Name) {
        "LAB-DC01" {
            Write-Step "Installing AD-Domain-Services and creating forest" ### Installing AD-Domain-Services and creating forest
            Invoke-Command -VMName LAB-DC01 -ScriptBlock { 
                Install-WindowsFeature -Name "ad-domain-services" -IncludeAllSubFeature -IncludeManagementTools
                Start-Sleep -Seconds 90
                Import-Module ADDSDeployment
                Start-Sleep 15
                Install-ADDSForest `
                -CreateDnsDelegation:$false `
                -DatabasePath "C:\Windows\NTDS" `
                -DomainMode "WinThreshold" `
                -DomainName "lab.local" `
                -DomainNetbiosName "LAB" `
                -ForestMode "WinThreshold" `
                -InstallDns:$true `
                -LogPath "C:\Windows\NTDS" `
                -NoRebootOnCompletion:$false `
                -SysvolPath "C:\Windows\SYSVOL" `
                -Force:$true `
                -SafeModeAdministratorPassword $Using:credentials.Password
            } -Credential $credentials
            Write-Step -Complete
        }
        "LAB-DC02" {
            Write-Step "Rebooting LAB-DC01" ### Rebooting LAB-DC01
            Start-Sleep -Seconds 400
            Write-Step -Complete
            Write-Step "Waiting for domain" ### Waiting for domain / LAB-DC01 to boot
            while ($online.Name -eq $null) {
                Start-Sleep -Seconds 60
                $online = Get-ADDomain "lab.local" -Server "lab-dc01" -Credential $credentials
            }
            Start-Sleep -Seconds 60
            Write-Step -Complete
            Write-Step "Installing AD-Domain-Services, joining domain and promoting to DC" ### Installing AD-Domain-Services, joining domain and promoting to DC
            Invoke-Command -VMName LAB-DC02 -ScriptBlock { 
                Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
                Add-Computer -DomainName "lab.local" -Server "lab-dc01" -Restart -Force -Credential $Using:domainCredentials
            } -Credential $credentials
            Start-Sleep -Seconds 400
            Invoke-Command -VMName LAB-DC02 -ScriptBlock { 
                Install-ADDSDomainController -SafeModeAdministratorPassword $Using:credentials.Password -DomainName "lab.local" -credential $Using:domainCredentials -Force
            } -Credential $domainCredentials
            Write-Step -Complete
        }
        Default {
            Write-Step "Joining domain" # Joining Domain
            Invoke-Command -VMName $Name -ScriptBlock {Add-Computer -DomainName "lab.local" -Server "lab-dc01" -Restart -Credential $Using:domainCredentials} -Credential $credentials
            Write-Step -Complete
        }
    }
}


###  CREATE OU STRUCTURE  ###

Invoke-Command -VMName LAB-DC01 -ScriptBlock { 
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
} -credential $domaincredentials | Out-Null


###  CREATE USERS  ###

Invoke-Command -VMName LAB-DC01 -ScriptBlock { 
    Add-Type -AssemblyName System.Web
    $Users = [ordered]@{                ### Userlist *doh*
        "Anders"    =   "Andersson"
        "Sune"      =   "Ulrikson"
        "Jennie"    =   "Johansson"
        "Jenny"     =   "Jakobsson"
        "Pernilla"  =   "Gangsterson"
        "Gurgel"    =   "Beer"
        "Johan"     =   "Hulten"
        "Maria"     =   "Gurgel"
        "Frida"     =   "Powershell"
        "Namnet"    =   "Grejen"
        "Hitta"     =   "Något"
        "Jörgen"    =   "Jörgenson"
        "Bertil"    =   "Bertilsson"
        "Johanna"   =   "Eriksson"
        "Öron"      =   "Näsa"
        "Munnen"    =   "Munsson"
        "Sebastian" =   "Scripting"
        "Mats"      =   "Lärare"
        "Erik"      =   "Teacher"
        "Martin"    =   "Chefen"
    }

    foreach ($User in $Users.Keys) {
        function Remove-StringLatinCharacters
        {
            PARAM ([string]$String)
            [Text.Encoding]::ASCII.GetString([Text.Encoding]::GetEncoding("Cyrillic").GetBytes($String))
        }
        $company = "lab.local"
        $ou = "OU=Users,OU=LAB,DC=lab,DC=local"
        $firstname = $User
        $lastname = $Users.item($User)
        $name = "$firstname $lastname"
        $username = (Remove-StringLatinCharacters -String ($firstname.Substring(0,3).ToLower() + $lastname.Substring(0,3).ToLower()))
        $password = [System.Web.Security.Membership]::GeneratePassword(10,1) | ConvertTo-SecureString -AsPlainText -Force
        $email = (Remove-StringLatinCharacters -String "$($name.Replace(" ", ".").ToLower())@$($company)")

        New-ADUser -Name $name `
            -SamAccountName $username `
            -DisplayName $name `
            -UserPrincipalName "$username@$company" `
            -GivenName $firstname `
            -Surname $lastname `
            -AccountPassword $password `
            -MobilePhone $phonenr `
            -EmailAddress $email `
            -Path $ou `
            -ChangePasswordAtLogon $true `
            -Enabled $true
    }
} -credential $domainCredentials | Out-Null


###  CREATE USER SHARES  ###

Start-Sleep -Seconds 180

Write-Step "Creating Share folder" ### Creating Share folder
Invoke-Command -VMName LAB-FILE01 -ScriptBlock { 
    New-Item –path "C:\Share\" -type directory -force
    New-SmbShare -Name "Shares$" -Path "C:\Share" | Grant-SmbShareAccess -AccountName Everyone -AccessRight Full -Force
} -credential $domainCredentials | Out-Null

Invoke-Command -VMName LAB-DC01 -ScriptBlock { 
    $adusers = $(Get-Aduser -Filter * -Searchbase "ou=users,ou=lab,dc=lab,dc=local" | Select-Object -ExpandProperty SamAccountName)
    $drivemap = "H:"
    ForEach ($user in $adusers) {
        $fullPath = "\\LAB-FILE01\Shares$\{0}" -f $user
        echo $fullPath
    
        if($user -ne $Null) { # If user exists
            Set-ADUser $user -HomeDrive $drivemap -HomeDirectory $fullPath -ea Stop
            $homeShare = New-Item -path $fullPath -ItemType Directory -force -ea Stop
            $acl = Get-Acl $homeShare
            $FileSystemRights = [System.Security.AccessControl.FileSystemRights]"Modify"
            $AccessControlType = [System.Security.AccessControl.AccessControlType]::Allow
            $InheritanceFlags = [System.Security.AccessControl.InheritanceFlags]"ContainerInherit, ObjectInherit"
            $PropagationFlags = [System.Security.AccessControl.PropagationFlags]"InheritOnly"
            $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($user, $FileSystemRights, $InheritanceFlags, $PropagationFlags, $AccessControlType)
            $acl.AddAccessRule($AccessRule)
            Set-Acl -Path $homeShare -AclObject $acl -ea Stop
            #Write-Host ("HomeDirectory created at {0}" -f $fullPath)
        }
    }
} -credential $domainCredentials | Out-Null
Write-Step -Complete

###  CREATE SHARED FOLDERS GEMENSAM AND RESURSER  ###

Write-Step "Creating Share folders GEMENSAM & RESURSER" ### Creating Common Share folders
Invoke-Command -VMName LAB-FILE01 -ScriptBlock { 
    New-Item –path "C:\Share\Gemensam" -type directory -force
    New-Item –path "C:\Share\Resurser" -type directory -force
    New-SmbShare -Name "Gemensam" -Path "C:\Share\Gemensam" | Grant-SmbShareAccess -AccountName Everyone -AccessRight Full -Force
    New-SmbShare -Name "Resurser" -Path "C:\Share\Resurser" | Grant-SmbShareAccess -AccountName Everyone -AccessRight Full -Force
} -credential $domainCredentials | Out-Null

Invoke-Command -VMName LAB-DC01 -ScriptBlock { 
    $fullPath = "\\LAB-FILE01\Shares$\Gemensam"
    $fullPath2 = "\\LAB-FILE01\Shares$\Resurser"
    $user = "Users"
        $shared = New-Item -path $fullPath -ItemType Directory -force -ea Stop
        $acl = Get-Acl $shared
        $FileSystemRights = [System.Security.AccessControl.FileSystemRights]"Modify"
        $AccessControlType = [System.Security.AccessControl.AccessControlType]::Allow
        $InheritanceFlags = [System.Security.AccessControl.InheritanceFlags]"ContainerInherit, ObjectInherit"
        $PropagationFlags = [System.Security.AccessControl.PropagationFlags]"InheritOnly"
        $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($user, $FileSystemRights, $InheritanceFlags, $PropagationFlags, $AccessControlType)
        $acl.AddAccessRule($AccessRule)
        Set-Acl -Path $shared -AclObject $acl -ea Stop
        $AccessRule = Get-Acl $fullPath
        New-Item -path $fullPath2 -ItemType Directory -force -ea Stop
        Set-Acl -Path $fullPath2 $AccessRule
} -credential $domainCredentials | Out-Null
Write-Step -Complete
