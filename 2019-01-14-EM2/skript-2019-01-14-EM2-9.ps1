<# 2019-01-14 EM2
Skript syntax - skript-<inlämningsuppgiftens datum>-<nummer>.ps1
9. Skapa ett script som går igenom eventloggen efter eventID 4624

Ta reda på hur många lyckade och misslyckade (Vilket event ID är det?) det finns.

Presentera :

- Totalt antal lyckade inloggningar
- Inloggningar via tangentbordet
- Inloggningar via nätverket
- Upplåsta inloggningar
- Misslyckade inloggningar (röd text).
- Skapa en fil (C:\Temp\Logins.txt) med resultatet. 
#>

# För att slippa se errors om någon av loggarna inte returnerar något värde.
$ErrorActionPreference = "SilentlyContinue"

# Kräver att man kör som admin
$successfulLogins = "Successful logins: " + (Get-WinEvent -FilterHashtable @{LogName = "Security"; ID = 4624}).Count
$interactiveLogins = "Interactive logins: " + (Get-WinEvent -FilterHashtable @{LogName = "Security"; ID = 4624} | Where-Object {$_.Properties[8].Value -eq 2}).Count
$networkLogins = "Network logins: " + (Get-WinEvent -FilterHashtable @{LogName = "Security"; ID = 4624} | Where-Object {$_.Properties[8].Value -eq 3}).Count
$unlockLogins = "Unlock logins: " + (Get-WinEvent -FilterHashtable @{LogName = "Security"; ID = 4624} | Where-Object {$_.Properties[8].Value -eq 7}).Count
$failedLogins = "Failed logins: " + (Get-WinEvent -FilterHashtable @{LogName = "Security"; ID = 4625}).Count

Write-Host $successfulLogins
Add-Content -Value $successfulLogins -Path "C:\Temp\Logins.txt"

Write-Host $interactiveLogins
Add-Content -Value $interactiveLogins -Path "C:\Temp\Logins.txt"

Write-Host $networkLogins
Add-Content -Value $networkLogins -Path "C:\Temp\Logins.txt"

Write-Host $unlockLogins
Add-Content -Value $unlockLogins -Path "C:\Temp\Logins.txt"

Write-Host $failedLogins -ForegroundColor "Red"
Add-Content -Value $failedLogins -Path "C:\Temp\Logins.txt"
