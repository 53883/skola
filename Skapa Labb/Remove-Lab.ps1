# Needed this.....when retrying for a million times before I got it right!!!!
# Remember to change the path to where your Hyper-V is located

$rootFolder = "E:\Hyper-V\TEST"
$VMs = "LAB-DC01", "LAB-DC02", "LAB-SRV01", "LAB-SRV02"

foreach ($VM in $VMs) {
    $vmInfo = Get-VM $VM -ErrorAction SilentlyContinue
    if ($vmInfo) {
        if ($vmInfo.State -eq "Running") {
            Stop-VM $VM -Force
            Start-Sleep 3
        }
        Remove-VM $VM -Force
    }
    if (Test-Path ($rootFolder + $VM)) {
        Remove-Item ($rootFolder + $VM) -Recurse -Force
    }
}
