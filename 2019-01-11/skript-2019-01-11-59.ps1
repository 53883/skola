<# 5.9  Exercise
1. Create a variable $a and assign it a value of 3 then use the write-host command to display the value.#>
$a=3
write-host $a

# 2. Type $a.GetType() to find the type of variable $a
$a.GetType() # its an integer

# 3. Create a variable $b and assign it a value of 3.3 then use the write-host command to display the value.
$b=3.3
write-host $b

# 4. Type $b.GetType() to find the type of variable $b 
$b.GetType() # its a double

# 5. Create a variable $c and assign it a value of "3.3" (include those quotes) then use the write-host command to display the value. 
$c="3.3"

# 6. Type $c.GetType() to find the type of variable $c 
$c.GetType() # its a string

# 7. Assign to a variable $d the sum of the first two variables by typing $d=$a + $b 
$d=$a + $b
write-host $d
$d.GetType()

# 8. What value is returned when you convert to integer the values 3.4 and 3.6? (This may be a surprise to those with Unix experience.)
what ?