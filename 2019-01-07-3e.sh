min=1000
max=10000
luck=7

number=62431
echo "$number start"

broken=$(( $number % 10 ))
echo "$broken Last digit"

number=$(( $number / 10 ))
#echo "$number whats left"

summa=$(( $summa + $broken ))
#echo "$summa summan"

broken=$(( $number % 10 ))
echo "$broken Last digit 2"

number=$(( $number / 10 ))
#echo "$number whats left"

summa=$(( $summa + $broken ))
#echo "$summa summan 1+2"

broken=$(( $number % 10 ))
echo "$broken Last digit 3"

number=$(( $number / 10 ))
#echo "$number whats left"

summa=$(( $summa + $broken ))
#echo "$summa summan 1+2+3"

broken=$(( $number % 10 ))
echo "$broken Last digit 4"

number=$(( $number / 10 ))
#echo "$number whats left"

summa=$(( $summa + $broken ))
#echo "$summa summan 1+2+3+4"

broken=$(( $number % 10 ))
echo "$broken Last digit 5"

number=$(( $number / 10 ))
#echo "$number whats left"

summa=$(( $summa + $broken ))
#echo "$summa summan 1+2+3+4+5"
