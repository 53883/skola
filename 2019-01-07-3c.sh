#!/bin/bash

# Script that echoes itself to stdout, but backwards #


#echo "Type a word"
#read x
#x=asdfg

# Count letters
#count=`echo -n $x | wc -c`
#echo $count


read x
echo $x | rev

