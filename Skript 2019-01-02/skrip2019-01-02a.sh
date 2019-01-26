#!/bin/bash

a=test-folder
b=test-file

if [ ! -d "$a" ];
then
	mkdir $a
else
	:
fi

if [ ! -f "$b" ];
then    
        touch $b
else
        :
fi

mv $b $a/$b
