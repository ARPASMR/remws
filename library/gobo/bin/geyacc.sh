#!/bin/sh
gcc -O2    -c geyacc2.c
gcc -O2    -c geyacc1.c
gcc  -lm -o geyacc geyacc1.o geyacc2.o  
