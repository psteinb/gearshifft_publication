#!/bin/bash
# $1 file
# $2 header skiprows
#for f in `ls *.1d.csv`; do
f="$1"
fstripped="${f##*/}"
    f2=${f%*.1d.csv}.2d.csv
    f3=${f%*.1d.csv}.3d.csv
    fnew=${fstripped%*.1d.csv}.csv
#    echo $fnew
    cp -i $f $fnew
    tail -n +$2 $f2 >> $fnew
    tail -n +$2 $f3 >> $fnew
#done
