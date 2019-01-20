#!/bin/bash

min=1000
max=10000
min2=$min
summary=0

while [ "$min" != "$max" ]
do
        while [ "$min" != "0" ]
        do  
                broken=$(( $min % 10 ))
                min=$(( $min / 10 ))
                summary=$(( $summary + $broken ))
        done

        if [ "$summary" = "7" ] 
        then    
                echo "$min2"
        fi      
 summary=0
 min2=$((min2 + 1))
 min=$min2
done
