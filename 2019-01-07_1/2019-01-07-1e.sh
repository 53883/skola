#!/bin/bash

# Script to print 10 9 8 7 6 5 4 3 2 1 #

x=10

while [ $x -ne 0 ];
do
	echo $x >> tempfile.txt
	x=$((x-1))
done

tr '\n' ' ' < tempfile.txt
echo ""
rm tempfile.txt
