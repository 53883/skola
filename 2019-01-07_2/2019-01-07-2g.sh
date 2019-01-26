#!/bin/bash

a=$(cat 2019-01-07-2a.txt | awk '{print $2}' | grep ^B)

for i in $a
do
	cat 2019-01-07-2a.txt | grep $i
done

# Inget namn börjar på B enligt din lista dock..... # 
