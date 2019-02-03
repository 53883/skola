# CREATE 4 VM'S #

#region HOST/VM-NAMES/IP #
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
