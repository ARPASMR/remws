#!/bin/sh
gcc -O2    -c geant5.c
gcc -O2    -c geant4.c
gcc -O2    -c geant3.c
gcc -O2    -c geant2.c
gcc -O2    -c geant1.c
gcc  -lm -o geant geant1.o geant2.o geant3.o geant4.o geant5.o  
