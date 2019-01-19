#!/bin/bash

min=1000
max=10000
luck=7
number=62431
echo $number
while [ $number != 0 ]
do
        broken=$(( $number % 10 ))
        echo "$broken Last digit"

        number=$(( $number / 10 ))
        #echo "$number whats left"

        summary=$(( $summary + $broken ))
        #echo "$summary summan"
done

