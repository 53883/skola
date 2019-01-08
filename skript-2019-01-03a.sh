#!/bin/bash

# variables
DATE=$(date +%Y-%m-%d)
REPORT=$DATE".report.txt"
FILE=$DATE".backup.tar.gz"
ERROR=$DATE".error.txt"

# Use find, use the -mmin flag and set it to 48hours, send output to output.txt
find /etc -mmin -$((60*48)) > $REPORT 2> /dev/null

# now tar it with the flag -T, each line is a file so to speak
tar -czf $FILE -T $REPORT 2> $ERROR

# REPORTS PRINTED TO THE USER?
read -n1 -p "Print report? (C)ompressed, (E)rrorlog or (B)oth" TEST
case $TEST in
        c|C) printf "\n\n"
                cat $REPORT ;;
        e|E) printf "\n\nBye\n\n" 
                cat $ERROR;;
        b|B) cat $REPORT
                printf "\n\n\nAND NOW THE ERRORLOG\n\n\n"
                cat $ERROR  ;;
        *) printf "\nWrong button, exiting because you fail\n" ;;
esac    

# Delete logs?
read -n1 -p "Delete logs? (Y)es, (N)o" TEST2
case $TEST2 in
	y|Y) printf "\n\nDeleting"
		rm $ERROR $REPORT ;;
	n|N) printf "\n\nHave a nice day\n\n" ;;
	*) printf "\n\nNot deleting reports\n\n" ;;
esac
