<# 11.4 Exercise
1. Create a CSV file of elements with values shown in Table 11.3 (page 27).#>

$elements = @(
    'Element,Symbol,Protons,Neutrons'
    'Iron,Fe,26,30'
    'Oxygen,O,8,8'
    'Hydrogen,H,1,0'
    'Carbon,C,6,6'
)
$elements | Export-Csv -Delimiter "," -Path C:\elements.csv
<# 
foreach ($element in $elements) {
    Add-Content -Path C:\elements.csv -Value $element
}
 #>
#ConvertTo-Csv -InputObject C:\elements.csv -Delimiter ","

# 2. Import the data into a variable $elements
$elements = Get-Content C:\elements.csv
write-host $elements | select något
# crap, and theeeen :-(

# 3. Calculate the average number of protons (tip = Measure-Object -average)


# 4. Print element symbols were the number of protons equals the number of neutrons.
