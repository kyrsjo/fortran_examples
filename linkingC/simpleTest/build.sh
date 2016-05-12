#! /usr/bin/env bash

# Example program to test C/Fortran linking, with Fortran calling a C library
# Written with a lot of inspiration from:
# http://www.yolinux.com/TUTORIALS/LinuxTutorialMixingFortranAndC.html
# https://software.intel.com/en-us/forums/archived-visual-fortran-read-only/topic/314274

CC=gcc
FC=gfortran

#With "underscore" name mangling when fortran calls external functions:
$CC -Wall -DUNDERSCORE -c cCode.c
$FC -Wall -funderscoring fCode.f cCode.o -o example_underscore

#With "underscore" name mangling when fortran calls external functions:
$CC -Wall -UUNDERSCORE -c cCode.c
$FC -Wall -fno-underscoring fCode.f cCode.o -o example_nounderscore
