$path = "C:\temp\"
$filePath = ($path + "grönsaker.txt")

# Gör en lista med fem olika grönsaker.
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

# Skriv in två grönsaker dubbelt i listan.
Add-Content -Value ($("Gurka", "Tomat")) -Path $filePath

# Sortera listan i bokstavsordning och med unikt förekommande grönsaker.
Get-Content $filePath | Sort-Object -Unique | Set-Content -Path $filePath

# Presentera de olika grönsakerna.
Get-Content -Path $filePath

# Och lägg in en slutrad med hur många unika grönsaker listan innehåller.
Add-Content -Value $(Get-Content $filePath).Count -Path $filePath