#!/bin/bash

files=files.txt
date=$(date +%Y-%m-%d)
targz=$date"-archive.tar.gz"
title="Select example"
find /usr/share/ -size +1M > files.txt
count=$(wc -l < files.txt)
prompt=$(printf "Its $count files in /usr/share.\n Pick an option:")

if [ $count -gt 10000 ]; then
	printf "\nWARNING: More then 10000 files\n\n"
elif [ $count -gt 1000 ]; then
	printf "\nWARNING: More then 1000 files\n\n"
elif [ $count -gt 100 ]; then
        printf "\nWARNING: More then 100 files\n\n"
elif [ $count -gt 10 ]; then
        printf "\nWARNING: More then 10 files\n\n"
fi

echo "test"
PS3="$prompt "
select opt in "Compress" "Quit"; do
    case "$REPLY" in
    1 ) tar -czvf $targz -T $files 2>/dev/null;break;;
    2 ) echo "Bye bye"; break;;
    *) echo "Choose either 1 or 2, try again";continue;;
    esac
done
