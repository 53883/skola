<# c. Skicka över resultatet på epost till er själva samt till mats.teacher@nackademin.se
OBS om ni inte har en SMTP server som ni kan använda för detta så kan ni skriva kommandot som en kommentar. 

Hej Mats! Jag är ej bekväm med att skicka all historikinformation utan att först gå igenom det (har en del jobbgrejer i min historik).
Du kan köra skriptet om du vill och få ut det från din dator =)
#>

# den här ligger med i det förra skriptet (variablen $htmlFile3), ska man maila den så vill man väl maila den då man kör skriptet tänkte jag.

Send-MailMessage -Subject "History comparison" -From "tomtem@nackademin.se" -To "mats.teacher@nackademin.se", "seplastian@hotmale.com" -Attachments $htmlFile3 -SmtpServer "har.ingen.smtp.se"