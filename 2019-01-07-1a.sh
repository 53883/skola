#!/bin/bash

# CHECK IF USER IS ONLINE #

echo "What user do you want to spy on?"
read user
user2="$(users | grep -w $user)"

if [ $user == $user2 ] 2> /dev/null
	then
		echo "$user is online"
	else
		echo "$user is NOT online"
fi
