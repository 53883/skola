#!/bin/bash

# VARIABLES #
min=1000
max=10000
min2=$min
summary=0
luck=7

# FIRST WHILE LOOP #
# counts to 10000 then stops #
while [ "$min" != "$max" ]
do
        while [ "$min" != "0" ] # 2ND WHILE # Stops when hitting 0 #
        do  
                broken=$(( $min % 10 )) # Modulus to remove last digit #
                min=$(( $min / 10 )) # remove last digit from startvalue #
                summary=$(( $summary + $broken )) # add all the sums #
        done

        # IF summary is 7, then print whole number #
        if [ "$summary" = "$luck" ]
        then
                echo "$min2"
        else # If not 7, calc if numbers get to 7 (1+3+3=7 for example) #
                a=$(( $summary % 10 ))
                b=$(( $summary / 10 ))
                c=$(( $a + $b ))

                        if [ "$c" = "$luck" ]
                        then
                                echo "$min2"
                        fi
        fi

# VARIABLES INSIDE THE WHILE LOOP #     
 summary=0
 min2=$(( min2 + 1 ))
 min=$min2
done
