# 4. Formatering
#Kör kommandot "Get-Service | Format-List" och beskriv vad "Format-List" gör.
Get-Service | Format-List
# Gets the services on the computer. 
# Formats the output as a list of properties in which each property appears on a new line. 

# Kör kommandot "Get-Service | Format-wide" och beskriv vad skillnaden är mot "Format-List".
Get-Service | Format-wide
# Formats objects as a wide table that displays only one property of each object. 
# You get several columns with -Column 5 for an example
Get-Service | Format-wide -Column 5