#!/bin/sh
gcc -O2    -c getest5.c
gcc -O2    -c getest4.c
gcc -O2    -c getest3.c
gcc -O2    -c getest2.c
gcc -O2    -c getest1.c
gcc  -lm -o getest getest1.o getest2.o getest3.o getest4.o getest5.o  
