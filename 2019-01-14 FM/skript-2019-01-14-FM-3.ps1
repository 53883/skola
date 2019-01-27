#3. Jämförelse
#Skapa en fil "C:\temp\test2.txt"
New-Item -ItemType Directory -Force -Path "C:\temp"
New-Item -ItemType File -Force -Name "test2.txt" -Path "C:\temp"

#Lägg in aktuell tid i filen.
$datum = $(Get-Date -UFormat "%Y-%m-%d")
Add-Content -Path C:\temp\test2.txt -Value "$datum"

#Lägg in texten "Välkommen hem" i filen.
$hem = "Välkommen hem"
Add-Content -Path C:\temp\test2.txt -Value $hem

#Jämför de test.txt med test2.txt och presentera resultatet.
Compare-Object -ReferenceObject $(Get-Content C:\temp\test.txt) -DifferenceObject $(Get-Content C:\temp\test2.txt)

<#
    Directory: C:\


Mode                LastWriteTime         Length Name                                                                                                                                         
----                -------------         ------ ----                                                                                                                                         
d-----       2019-01-27     12:26                temp                                                                                                                                         


    Directory: C:\temp


Mode                LastWriteTime         Length Name                                                                                                                                         
----                -------------         ------ ----                                                                                                                                         
-a----       2019-01-27     12:29              0 test2.txt                                                                                                                                    

InputObject   : Välkommen hem
SideIndicator : =>


InputObject   : Välkommen till Nackademin
SideIndicator : <=

#>