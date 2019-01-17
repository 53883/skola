#!/bin/bash

# Script that prompts user for a starting value & counts down from there #

read value

while [ $value -ne 0 ];
do
	value=$((value-1))
	echo $value
	sleep 0.1
done

