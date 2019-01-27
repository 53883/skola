$path = "C:\temp\"
$filePath = ($path + "gr�nsaker.txt")

# G�r en lista med fem olika gr�nsaker.
$gronsaker = @(
    "Gurka"
    "Tomat"
    "Avokado"
    "Paprika"
    "Apelsin"
)

if (!(Test-Path $path)) {
    New-Item $path -Force
}

# Skapa en fil "C:\temp\gronsaker.txt"
Add-Content -Value $gronsaker -Path $filePath

# Skriv in tv� gr�nsaker dubbelt i listan.
Add-Content -Value ($("Gurka", "Tomat")) -Path $filePath

# Sortera listan i bokstavsordning och med unikt f�rekommande gr�nsaker.
Get-Content $filePath | Sort-Object -Unique | Set-Content -Path $filePath

# Presentera de olika gr�nsakerna.
Get-Content -Path $filePath

# Och l�gg in en slutrad med hur m�nga unika gr�nsaker listan inneh�ller.
Add-Content -Value $(Get-Content $filePath).Count -Path $filePath