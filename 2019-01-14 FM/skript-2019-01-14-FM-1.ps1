<#1. Skapa och formatera filer:
Skapa en katalog "C:\temp".#>
New-Item -ItemType Directory -Force -Path "C:\temp"

# Skapa en fil i ovan katalog med namnet "test.txt".
New-Item -ItemType File -Force -Name "test.txt" -Path "C:\temp"

# Lägg till dagens datum som text i test.txt.
$datum = $(Get-Date -UFormat "%Y-%m-%d")
Add-Content -Path C:\temp\test.txt -Value "$datum"

# Lägg in texten "Välkommen till Nackademin" i test.txt.
$nackademin = "Välkommen till Nackademin"
Add-Content -Path C:\temp\test.txt -Value $nackademin

# Radera innehållet i filen
Clear-Content "C:\temp\test.txt"

# Lägg in texten "Välkommen till Nackademin" i test.txt.
Add-Content -Path C:\temp\test.txt -Value "$nackademin"

#Lägg till dagens datum i test.txt.
Add-Content -Path C:\temp\test.txt -Value "$datum"