<# 3.1  Exercise
1. Type write-host "Hello World" and press the Enter key
2. Type write-host -foregroundcolor yellow "Hello World"
3. Get PowerShell to print in blue text on a yellow background? Clue, use the -backgroundcolor parameter.
4. Type help clear-host -online What happens? #>

write-host "Hello World"
write-host -ForegroundColor Yellow "Hello World"
Write-Host -ForegroundColor Blue -BackgroundColor Yellow "Hello World"
Clear-Host -online # clears the screen