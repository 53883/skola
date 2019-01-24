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
#$VMS = @("LAB-DC01", "LAB-DC02", "LAB-SRV01", "LAB-SRV02")
$VMs = [ordered]@{
    "LAB-DC01"  = "10.0.0.10"
    "LAB-DC02"  = "10.0.0.11"
    "LAB-SRV01" = "10.0.0.12"
    "LAB-SRV02" = "10.0.0.13"
}
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

foreach ($vm in $VMS.Keys) {
    $vm_path = $root_path + $vm
    $vhd_path = $vm_path + "\Virtual Hard Disks\"
    $vhd_file = $vm + ".vhdx"
    #region COPY TEMPLATE VHDX and CREATE PATH
    New-Item -ItemType Directory -Force -Path $vhd_path
    Copy-Item "$template_vhd" -Destination "$vhd_path$vhd_file"
    #endregion
   
    New-VM -Name $vm -Path $root_path -MemoryStartupBytes $memory -VHDPath $vhd_path$vhd_file -Generation $gen -SwitchName $vm_switch
}

<# foreach ($vm in $VMS.Keys) {

    $ip = $VMS.Item($vm)
    Invoke-Command -ComputerName $vm -ScriptBlock { 
        New-NetIPAddress -InterfaceAlias "Ethernet" -IPAddress $Using:ip -AddressFamily "IPv4" -DefaultGateway $Using:gw -PrefixLength 24 -WhatIf
    } -credential $credentials
} #>


<#
cmd's visual studio code

* formatera kod = shift + alt  f
* kopiera en rad = Shift + ALT NER
* multi-line editing = CTRL + ALT UPP/NER. ESC två gånger = CANCEL
* block comment = markera skit och shift + alt  a
    samma för att avkommentera
#>

#region IP ADDRESSES 
#$ip1 = "10.0.0.10"
#$ip2 = "10.0.0.11"
#$ip3 = "10.0.0.12"
#$ip4 = "10.0.0.13"
#$gw = "10.0.0.1"
#$subnet = "255.255.255.0"
#$dns1 = "10.0.0.1" #temp
#$dns2 = "172.29.90.11"
#endregion 

<#

IPAddress         : 172.29.90.150
InterfaceIndex    : 6
InterfaceAlias    : Ethernet
AddressFamily     : IPv4
Type              : Unicast
PrefixLength      : 28
PrefixOrigin      : Dhcp
SuffixOrigin      : Dhcp
AddressState      : Preferred
ValidLifetime     : 23:59:11
PreferredLifetime : 23:59:11
SkipAsSource      : False
PolicyStore       : ActiveStore

#>
