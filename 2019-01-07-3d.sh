#!/bin/bash

# Write a script function that determines if an argument passed to it is an integer or a string. The function will return TRUE(0) if passed as an integer, and FALSE(1) if passed as a string #

read test
if [ "${test//[0-9]}" = "" ];
then
	echo integer
elif [ "${test//[a-z]}" = "" ];
then
	echo string
else
	echo "Its neither a string or a integer"
fi
