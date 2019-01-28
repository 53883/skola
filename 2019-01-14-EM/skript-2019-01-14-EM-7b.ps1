<# b. Webbsida "kommandon-<dagensdatum>.html"
- Spara undan historiken från idag i en fil med dagens datum.
- Skapa också en webbsida med vilka unika kommandon som har skrivits in i historik filen.
- Om kommandot körs varje dag så ska en jämförelse göras mot gårdagens historik fil och presenteras som en differens (gårdagen mot dagens historik).
- Presentera en formaterad webbsida (exempel: https://www.powershellbros.com/create-your-own-html-report-email/) med resultatet. #>

$historyFileT = "C:\temp\" + $(Get-Date).ToShortDateString() + "-history.txt"
$historyFileY = "C:\temp\" + $(Get-Date).AddDays(-1).ToShortDateString() + "-history.txt"
$historyFileT
$historyFileY
$htmlFile2 = "C:\temp\kommandon-" + (Get-Date).ToShortDateString() + ".html"

# - Spara undan historiken från idag i en fil med dagens datum.
Get-History | Select-Object CommandLine | Out-File $historyFileT
#- Skapa också en webbsida med vilka unika kommandon som har skrivits in i historik filen.
Get-Content $historyFileT | Sort-Object -Unique | ConvertTo-Html -Head $Head -PreContent "<h1>Unique history</h1>" | Add-Content $htmlFile2
# - Om kommandot körs varje dag så ska en jämförelse göras mot gårdagens historik fil och presenteras som en differens (gårdagen mot dagens historik).
if (Test-Path $historyFileY) {
    $htmlFile3 = "C:\temp\compare_" + (Get-Date).ToShortDateString() + ".html"
    $yesterday = Get-Content $historyFileY
    $today = Get-Content $historyFileT
    Compare-Object $today $yesterday | ConvertTo-Html -Head $Head -PreContent "<h1>History comparison</h1>" | Add-Content $htmlFile3
}
else {Write-Host "Nothing to compare with"}


# Ejecta CD-ROM och läs upp texten "Command complete" med "SAPI.SPVoice" för att tala om att kommandot är färdigt.
$speak = New-Object –ComObject SAPI.SPVoice
$drives = Get-WmiObject Win32_Volume -Filter "DriveType=5"
if ($drives -eq $null) {
    $speak.Speak("Your computer has no CD drives to eject.")
    return
} 
$drives | ForEach-Object {
    (New-Object -ComObject Shell.Application).Namespace(17).ParseName($_.Name).InvokeVerb("Eject")
    $speak.Speak("Your ancient CD-ROM has been ejected")
}

<# c. Skicka över resultatet på epost till er själva samt till mats.teacher@nackademin.se
OBS om ni inte har en SMTP server som ni kan använda för detta så kan ni skriva kommandot som en kommentar. 

Hej Mats! Jag är ej bekväm med att skicka all historikinformation utan att först gå igenom det (har en del jobbgrejer i min historik).
Du kan köra skriptet om du vill och få ut det från din dator =)
#>
Send-MailMessage -Subject "History comparison" -From "tomtem@nackademin.se" -To "mats.teacher@nackademin.se", "seplastian@hotmale.com" -Attachments $htmlFile3 -SmtpServer "har.ingen.smtp.se"