# 5. Where
# Lista alla tjänster (Services) som är startade.
Get-Service | Where-Object {$_.Status -eq "Running"}