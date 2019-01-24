<# Skapa en miljö bestående av:
- 2st Windows 2019 servrar i rollen domän kontroller.
- 2st Windows 2016 servrar i rollen member servers..
Skapa 20 st användare, använd tex. "test data  skapar sidan" http://www.databasetestdata.com/ , för att skapa grunddata.
Skapa sedan användare med namnstandarden, tre första bokstäverna från förnamnet och sedan de tre första bokstäverna i efternamnet.
Skapa fildelningsområden (Shares folders) på alla servrar:
- Gemensam
- Resurser
- Privat för varje användare
Gemensam och resurser ska alla användare ha tillgång till.
Privat ska skapas som hidden med användarnamn som "Share folder namn".
IP, nätverk mm skapas utifrån egen diskretion.#>

#region USER INPUT #
Write-Host "Enter VM admin credentials"
$credentials = Get-Credential
#endregion

#region HOST/VM-NAMES #
$VMS = @("LAB-DC01", "LAB-DC02", "LAB-SRV01", "LAB-SRV02")
#endregion

#region LOCATIONS #
$root_path = "E:\Hyper-V\VMLAB\"
$template_vhd = "E:\Hyper-V\VMLAB\LAB-TEMPLATE\Virtual Hard Disks\LAB-TEMPLATE.vhdx"
#endregion

#region VM CONFIG VARIABLES #
$gen = 2
$memory = 4GB
$vm_switch = "Lab-Switch"
#endregion

foreach ($vm in $VMS) {
    $vm_path = $root_path + $vm
    $vhd_path = $vm_path + "\Virtual Hard Disks\"
    $vhd_file = $vm + ".vhdx"
    #region COPY TEMPLATE VHDX and CREATE PATH
    New-Item -ItemType Directory -Force -Path $vhd_path
    Copy-Item "$template_vhd" -Destination "$vhd_path$vhd_file"
    #endregion
   
    New-VM -Name $vm -Path $root_path -MemoryStartupBytes $memory -VHDPath $vhd_path$vhd_file -Generation $gen -SwitchName $vm_switch
    
    <# 
    Invoke-Command -ComputerName $vm -ScriptBlock { 
        New-NetIPAddress -InterfaceAlias "Ethernet" -IPAddress $Using:ip1 -AddressFamily "IPv4" -DefaultGateway $Using:gw -PrefixLength 24 -WhatIf
    } -credential $credentials #>
}
