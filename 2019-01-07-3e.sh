#!/bin/bash

min=9000
max=9050
min2=$min
summary=0

while [ "$min" != "$max" ]
do
        while [ "$min" != "0" ]
        do  
                broken=$(( $min % 10 ))
                min=$(( $min / 10 ))
                summary=$(( $summary + $broken ))
#echo $summary
        done

        if [ "$summary" = "7" ] 
        then    
                echo "$min2"
        else
                a=$(( $summary % 10 ))
                b=$(( $summary / 10 ))
                c=$(( $a + $b ))

                        if [ "$c" = "7" ]
                        then
                                echo "$min2"
                        fi
        fi
 summary=0
 min2=$((min2 + 1))
 min=$min2
done
