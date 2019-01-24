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

#region HOST/VM-NAMES #
$dc01   =   "LAB-DC01"
$dc02   =   "LAB-DC02"
$srv01  =   "LAB-SRV01"
$srv02  =   "LAB-SRV02"

#---------- make a loop here ---------#
#---------- make a loop here ---------#
$vm_name = $dc01
#endregion

#region LOCATIONS #
$root_path      =   "E:\Hyper-V\VMLAB\"
$vm_path        =   "$root_path$vm_name"
$vhd_path       =   "$vm_path`\Virtual Hard Disks\"
$vhd_file       =   "$vm_name.vhdx"
$template_vhd   =   "E:\Hyper-V\VMLAB\LAB-TEMPLATE\Virtual Hard Disks\LAB-TEMPLATE.vhdx"
$vhd_name       =   "$vm_name.vhdx"
#endregion

#region VM CONFIG VARIABLES #
#$vcpu          =   2
$gen            =   2
$memory         =   4GB
$vm_switch      =   "Default Switch"
#endregion

#region COPY TEMPLATE VHDX and CREATE PATH
New-Item -ItemType Directory -Force -Path $vhd_path
Copy-Item "$template_vhd" -Destination "$vhd_path$vhd_name"
#region CREATE THE VM

#region CREATE VM #
New-VM -Name $vm_name -Path $root_path -MemoryStartupBytes $memory -VHDPath $vhd_path$vhd_file -Generation 2 -SwitchName $vm_switch
#endregion
