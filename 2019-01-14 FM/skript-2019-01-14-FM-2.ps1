# Gör en lista med fem olika grönsaker.
$gronsak = @(
    'Gurka'
    'Tomat'
    'Apelsin'
    'Avokado'
    'Paprika'
)

# Skapa en fil "C:\temp\gronsaker.txt"
New-Item -ItemType Directory -Force -Path "C:\temp"
New-Item -ItemType File -Force -Name "gronsaker.txt" -Path "C:\temp"

# Skriv in två grönsaker dubbelt i listan.
$gronsak += "Gurka", "Tomat"

# Sortera listan i bokstavsordning och med unikt förekommande grönsaker.
$gronsak | Sort-Object -Unique | Out-File -FilePath C:\temp\gronsaker.txt

# Presentera de olika grönsakerna.
$gronsak -join ' '

# Och lägg in en slutrad med hur många unika grönsaker listan innehåller.
