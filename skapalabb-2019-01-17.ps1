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
Write-Host "Enter the Virtual Machine Name"
$vmname = Read-Host
#endregion

#region LOCATIONS #
$path           =   "C:\Users\sebastian\Documents\Hyper-V\"
$vmloc          =   "C:\Users\sebastian\Documents\Hyper-V\$vmname"
$vhdpath        =   "$vmloc`\Virtual Hard Disks\"
$vhdfile        =   "$vmname.vhdx"
$template_vhd   =   "C:\Users\sebastian\Documents\Hyper-V\Templates\Win2016D\Win2016\Virtual Hard Disks\Win2016.vhdx"

#endregion

#region VM VARIABLES #
$cpu            =   2
$gen            =   2
$memory         =   3GB
$vhdname        =   "$vmname.vhdx"
$vmswitch       =   "Default Switch"

#endregion

#region COPY TEMPLATE VHDX and CREATE PATH
New-Item -ItemType Directory -Force -Path $vhdpath
Copy-Item "$template_vhd" -Destination "$vhdpath$vhdname"

#region CREATE THE VM
New-VM -Name $vmname -Path $path -MemoryStartupBytes $memory -VHDPath $vhdpath$vhdfile -Generation 2 -SwitchName $vmswitch
#New-VM -Name $vmname -MemoryGB $memory -Path $vmpath -Generation $gen -Switch $vmswitch
#Hyper-V\New-VM -VHDPath $vhdpath -BootDevice VHD -Name $vmname -Generation 2 -MemoryStartupBytes $memory -Path $vmloc -SwitchName "Default Switch"

#endregion

#New-VM -Name test -Path "C:\Users\sebastian\Documents\Hyper-V\" -MemoryStartupBytes 3GB -VHDPath "C:\Users\sebastian\Documents\Hyper-V\test\Virtual Hard Disks\test.vhdx" -Generation 2 -SwitchName "Default Switch"
#New-VM -Name $vmname -Path $path -MemoryStartupBytes $memory -VHDPath $vhdpath -Generation 2 -SwitchName $vmswitch
