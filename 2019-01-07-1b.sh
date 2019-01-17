#!/bin/bash

# IS THE FILE +X? IF NOT, MAKE IT #

echo "What file do you want to check?"
read file

if [[ -x "$file" ]]
then
	echo "File is executable!"
else
	chmod +x $file 2> /dev/null && echo "Now the file is executable" || echo "You can not execute it, and you can't chmod it!"
fi
