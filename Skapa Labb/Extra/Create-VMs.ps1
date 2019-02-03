workflow Create-VMs {
    # CREATE 4 VM'S #
    #region HOST/VM-NAMES/IP #
    $VMs = [ordered]@{
        "LAB-TEST"  = "10.0.0.10"
        "LAB-DC02"  = "10.0.0.11"
        "LAB-SRV01" = "10.0.0.12"
        "LAB-SRV02" = "10.0.0.13"
    }
    <#$VMsmask = [ordered]@{
        "LAB-TEST"  = "255.255.255.0"
        "LAB-DC02"  = "255.255.255.0"
        "LAB-SRV01" = "255.255.255.0"
        "LAB-SRV02" = "255.255.255.0"
    }#>
    <#$VMsgw = [ordered]@{
        "LAB-TEST"  = "10.0.0.1"
        "LAB-DC02"  = "10.0.0.1"
        "LAB-SRV01" = "10.0.0.1"
        "LAB-SRV02" = "10.0.0.1"
    }#>
        <#$VMsdns = [ordered]@{
        "LAB-TEST"  = "10.0.0.1"
        "LAB-DC02"  = "10.0.0.10"
        "LAB-SRV01" = "10.0.0.10"
        "LAB-SRV02" = "10.0.0.10"
    }#>

    #endregion

    #region XML
    $xml = "E:\Hyper-V\VMLAB\unattend.xml"
    $xmlDestination = "F:\Windows\Panther\" # https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-8.1-and-8/hh824950(v=win.10)
    #endregion

    #region LOCATIONS #
    $root_path = "E:\Hyper-V\VMLAB"
    $template_vhd = "E:\Hyper-V\VMLAB\LAB-TEMPLATE\Virtual Hard Disks\LAB-TEMPLATE.vhdx"
    Mount-VHD  $template_vhd 
    Start-Sleep -Seconds 3
    Copy-Item $xml $xmlDestination 
    Dismount-VHD $template_vhd
    #endregion

    #region VM CONFIG VARIABLES #
    $gen = 2
    $memory = 4GB
    $vm_switch = "Lab-Switch"
    #endregion
    foreach -Parallel ($vm in $VMS.Keys) {
        $VMs[$vm]
        $w[$vm]
        $VMs[$vm]
        $vm_path = $root_path + $vm
        $vhd_path = $vm_path + "\Virtual Hard Disks\"
        $vhd_file = $vm + ".vhdx"
        #region COPY TEMPLATE VHDX and CREATE PATH
        New-Item -ItemType Directory -Force -Path $vhd_path
        Copy-Item "$template_vhd" -Destination "$vhd_path$vhd_file"
        #endregion
   
        New-VM -Name $vm -Path $root_path -MemoryStartupBytes $memory -VHDPath $vhd_path$vhd_file -Generation $gen -SwitchName $vm_switch
    }
    
}

Measure-Command {Create-VMs}

<# 
HÄR SKRIVER MAN VIKTIGA SAKER!

¯\_(ツ)_/¯

#>
