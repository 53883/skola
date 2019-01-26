#!/bin/bash

sort -t $'\t' -k 5,5 -V 2019-01-07-2a.txt
echo ""
sort -t $'\t' -k 4,4 -V -r 2019-01-07-2a.txt
