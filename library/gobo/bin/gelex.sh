#!/bin/sh
gcc -O2    -c gelex2.c
gcc -O2    -c gelex1.c
gcc  -lm -o gelex gelex1.o gelex2.o  
