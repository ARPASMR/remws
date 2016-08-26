#!/bin/sh
gcc -O2    -c gexace4.c
gcc -O2    -c gexace3.c
gcc -O2    -c gexace2.c
gcc -O2    -c gexace1.c
gcc  -lm -o gexace gexace1.o gexace2.o gexace3.o gexace4.o  
