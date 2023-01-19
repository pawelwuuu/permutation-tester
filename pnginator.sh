#!/bin/bash

title=$(tail -n 1 input.txt)
output_file=$title.png

head -n -1 input.txt | sort -n > sorted_file.txt

gnuplot <<- EOF
set datafile separator ' '
set title "permutacje"
set xlabel "permutacje"
set ylabel "czas"
set key top right
set grid
set term png
set output "$output_file"
plot 'sorted_file.txt' using 1:2 with lines
EOF