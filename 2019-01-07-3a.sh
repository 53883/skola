#!/bin/bash

# Script that asks for the user's favorite color and if it is not 'red' informs him that it is wrong answer, waits for 3sec, clears the screen and asks the question again #

echo "What is your favourite colour?"
read colour
colour2=${colour,,}

while [ "$colour2" != "red" ]
do
	echo "Wrong answer"
	sleep 3
	clear
	echo "Try again"
	read colour
	colour2=${colour,,}
done

echo "Good answer!"
