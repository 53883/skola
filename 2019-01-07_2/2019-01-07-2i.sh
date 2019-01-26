#!/bin/bash

touch "file 1"
a=$(cat 2019-01-07-2a.txt) # whole file
b=$(echo "$a" | awk -F $'\t' '{print $5}') # extract tab 5
c=$(echo "$a" | wc -l) # rows in $a
d=1 # counter

while [ $c != 0 ]
do
	for i in $b;
	do
		e=$(echo "$b" | sed -n "$d"p | sed 's/\.[^.]*$//')
		if [ "$e" -ge 10000 ] && [ "$e" -le 15000 ];
		then
			echo "$a" | sed -n "$d"p | awk -F $'\t' '{print $2}' >> "file 1"
		fi
	d=$[ $d + 1 ]
	c=$[ $c - 1 ]
	done
done
