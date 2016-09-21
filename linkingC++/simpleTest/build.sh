#! /usr/bin/env bash

# Example program to test C/Fortran linking, with Fortran calling a C library
# Written with a lot of inspiration from:
# http://www.yolinux.com/TUTORIALS/LinuxTutorialMixingFortranAndC.html
# https://software.intel.com/en-us/forums/archived-visual-fortran-read-only/topic/314274

#Echo and expand every command
set -o verbose
set -o xtrace

CC=gcc
CXX=g++
FC=gfortran

#With "underscore" name mangling when fortran calls external functions:
#$CC -Wall -DUNDERSCORE -c cCode.c
$CXX -Wall -DUNDERSCORE -c cppCode.cpp -g
$FC -Wall -funderscoring fCode.f cppCode.o -o example_underscore -lstdc++ -g

#With "underscore" name mangling when fortran calls external functions:
#$CC -Wall -UUNDERSCORE -c cCode.c
$CC -Wall -UUNDERSCORE -c cppCode.cpp -g
$FC -Wall -fno-underscoring fCode.f cppCode.o -o example_nounderscore -lstdc++ -g
