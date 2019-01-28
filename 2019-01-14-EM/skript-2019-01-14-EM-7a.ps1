<# 2019-01-14 EM
Skript syntax: skript-<inlämningsuppgiftens datum>-<nummer>.ps1
7. Skapa en status webbsida (fil) med följande innehåll
a. Webbsida "fel.html"
- Totalt antal Warningar, error från system loggen (event).
- Hur många Warningar, error har tillkommit de sista 24 timmarna.
- Vilka är de 100 sista unika Warningar, error meddelande.
- Är det mer än 10 nya Warningar, error meddelanden, skriv  ut ett varningsmeddelande.
- Presentera en formaterad webbsida (exempel: https://www.powershellbros.com/create-your-own-html-report-email/) med resultatet. #>
$htmlFile = "C:\temp\fel.html"

# Totalt antal Warningar, error från system loggen (event).
$warnings = Get-WinEvent -FilterHashtable @{LogName = "System"; Level = 3}
$errors = Get-WinEvent -FilterHashtable @{LogName = "System"; Level = 2}

# Hur många Warningar, error har tillkommit de sista 24 timmarna.
$warnings24h = $warnings | where {$_.TimeCreated -ge (Get-Date).AddDays(-1)}
$errors24h = $errors | where {$_.TimeCreated -ge (Get-Date).AddDays(-1)}

# Vilka är de 100 sista unika Warningar, error meddelande.
$warningsUnique = $warnings | Select-Object "Id", "LevelDisplayName", "Message" -Unique | Select-Object -Last 100
$errorsUnique = $errors | Select-Object "Id", "LevelDisplayName", "Message" -Unique | Select-Object -Last 100

# Presentera en formaterad webbsida 
$Head = @"
<style>
  body {
    font-family: "Arial";
    font-size: 8pt;
    color: #4C607B;
    }
  th, td { 
    border: 1px solid #e57300;
    border-collapse: collapse;
    padding: 5px;
    }
  th {
    font-size: 1.2em;
    text-align: left;
    background-color: #003366;
    color: #ffffff;
    }
  td {
    color: #000000;
    }
  .even { background-color: #ffffff; }
  .odd { background-color: #bfbfbf; }
</style>
"@

ConvertTo-Html -Body "<h1>Warnings: $($warnings.Count)<br>Errors: $($errors.Count)</h1>" | Add-Content $htmlFile

# Är det mer än 10 nya Warningar, error meddelanden, skriv  ut ett varningsmeddelande.
if ($warnings.Count -gt 10) {
    ConvertTo-Html -Head $Head -Body "<h2><p>More than 10 warnings!</p></h2>" | Add-Content $htmlFile
}
if ($errors.Count -gt 10) {
    ConvertTo-Html -Head $Head -Body "<h2><p>More than 10 errors!</p></h2>" | Add-Content $htmlFile
}

ConvertTo-Html -Body "<h1>Warnings last 24h: $($warnings24h.Count)<br>Errors last 24h: $($errors24h.Count)</h1>" | Add-Content $htmlFile

$warningsUnique | ConvertTo-Html -Head $Head -PreContent "<h1>Last 100 unique warnings:</h1>" | Add-Content $htmlFile
$errorsUnique | ConvertTo-Html -Head $Head -PreContent "<h1>Last 100 unique errors:</h1>" | Add-Content $htmlFile