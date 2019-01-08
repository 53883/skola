#!/bin/bash

file2a="https://github.com/53883/skola/blob/master/skript2019-01-02a.sh"
folder2="folder2"
file2b="skript2019-01-02a.sh"

wget $file2a
mkdir -p $folder2
mv $file2b $folder2
