#!/bin/bash

while true;
do
	echo "1. ls"
	echo "2. pwd"
	echo "3. ls -l"
	echo "4. ps -fe"
	echo "5. Quit"

	read test

	case $test in 
		1) ls ;;
		2) pwd ;;
		3) ls -l ;;
		4) ps -fe ;;
		5) exit ;;
		*) echo "Wrong choice, pick 1-4"
	esac
done

