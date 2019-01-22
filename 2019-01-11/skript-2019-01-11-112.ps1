<# 11.2  Exercise
Using powershell calculate if you have lived for: #>
$sebbe = (Get-Date -Date "1981-04-27")
$today = Get-Date
$result = $today - $sebbe

#1. A million seconds?
if ($result.TotalSeconds -ge 1000000) {
    write-host "You lived longer then 1mil seconds"
    write-host "You've lived for $($result.TotalSeconds) seconds"
}
else {
    Write-Host "You are young"
}    

# 2. A million minutes?
if ($result.TotalMinutes -ge 1000000) {
    write-host "You lived longer then 1mil minutes"
    write-host "You've lived for $($result.TotalMinutes) minutes" 
}
else {
    Write-Host "You are young"
}   

# 3. A million hours?
if ($result.TotalHours -ge 1000000) {
    write-host "You lived longer then 1mil hours"
    write-host "You've lived for $($result.TotalHours) hours"
}
else {
    Write-Host "You are young"
} 

# 4. Calculate your age in units of millions of minutes.
Write-Host "You've lived for $($result.TotalMinutes / 1000000) millions of minutes"
