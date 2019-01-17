#!/bin/bash

# Script that replaces all "*.txt" file names with "*.txt.old" in the current (directory?) #

#ls -1a | grep -i ".txt" > temp
#for i in temp
for i in *.txt
do
	mv -- "$i" "${i}.old"
done
