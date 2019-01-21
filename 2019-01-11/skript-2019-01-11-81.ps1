<#8.1  Exercise
1. Create and save a text file with notepad.exe containing your address. Call the file address.txt. Use get-content to display the file address.txt contents.#>
Add-Content -Path C:\address.txt -Value "Min adress 54"
Get-Content -Path C:\address.txt

# 2. Assign the contents of address.txt to a variable $address and display the contents.
$address=Get-Content C:\address.txt
Write-Host $address

# 3. Create a multi-line string variable $workaddress with your work address 
$workaddress = @"
Min adress 54
Sundbyberg
Sverige
"@
write-host $workaddress

<# 4. Create a variable $myname with your firstname and surname in it. 
Use the pipe symbol and gm to work out what methods are available to make it all uppercase or lowercase.#>
$myname = "Anders Andersson"
$myname | Get-Member
$myname.ToUpper()
$myname.ToLower()