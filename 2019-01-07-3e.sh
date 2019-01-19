#!/bin/bash

min=1000
max=10000
luck=7

number=9876

broken=$(( $number % 10 ))
echo $broken

number=$(( $number / 10 ))
echo $number

summa=$(( $summa + $broken ))
echo $summa

broken=$(( $number % 10 ))
echo $broken
