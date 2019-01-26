#!/bin/bash

a=$(cat 2019-01-07-2a.txt | grep E2)
b=$(echo "$a" | awk -F $'\t' '{print $4}')
c=$(echo "$a" | wc -l)
d=1

while [ $c != 0 ]
do
	for i in $b; 
	do
		e=$(echo "$b" | sed -n "$d"p)
		if [ "$e" -ge 2 ] && [ "$e" -le 5 ];
		then
			echo "$a" | sed -n "$d"p
		fi
	d=$[ $d + 1 ]
	c=$[ $c - 1 ]
	done
done
