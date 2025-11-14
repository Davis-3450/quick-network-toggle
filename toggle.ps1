$adapters = Get-NetAdapter -Physical `
    | Where-Object {
        $_.Status -ne "Unknown" -and $_.HardwareInterface
    } `
    | Where-Object {
        $_.Name -notmatch 'Virtual|Hyper-V|VMware|VirtualBox|TAP|Loopback' -and
        $_.InterfaceDescription -notmatch 'Virtual|Hyper-V|VMware|VirtualBox|TAP|Loopback'
    }

if (-not $adapters) {
    Write-Host "No valid physical Ethernet adapter found." -ForegroundColor Red
    exit
}

$adapter = $adapters | Select-Object -First 1

Write-Host "Detected physical adapter: $($adapter.Name) ($($adapter.InterfaceDescription))"

if ($adapter.Status -eq "Up") {
    Write-Host "Disabling..."
    Disable-NetAdapter -Name $adapter.Name -Confirm:$false
} else {
    Write-Host "Enabling..."
    Enable-NetAdapter -Name $adapter.Name -Confirm:$false
}
