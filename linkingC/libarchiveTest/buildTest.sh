#! /usr/bin/env bash

if [ ! -d libarchive_build ]; then
    echo "LibArchive not found, building.."
    ./buildLibArchive.sh
else
    echo "LibArchive already exists"
fi

#Echo and expand every command
set -o verbose
set -o xtrace

#Build the wrapper
echo "Building libArchive_wrapper.o..."
gcc -Wall -g -Ilibarchive/libarchive/ -c libArchive_wrapper.c

echo
echo "*****************************************************************"
echo

#Build static test_libarchive:
echo "Building test_libarchive_static..."
gcc -static -Wall -g test_libarchive.c libArchive_wrapper.o libarchive_build/libarchive/libarchive.a -lz -lpthread -o test_libarchive_static
./test_libarchive_static

echo
echo "*****************************************************************"
echo

#Build dynamic test_libarchive:
echo "Building test_libarchive_dynamic..."
gcc -Wall -g test_libarchive.c libArchive_wrapper.o -Llibarchive_build/libarchive/ -larchive -lz -o test_libarchive_dynamic
#echo "Done, to run, use"
#echo "LD_LIBRARY_PATH=libarchive_build/libarchive/ ./test_libarchive_dynamic"
LD_LIBRARY_PATH=libarchive_build/libarchive/ ./test_libarchive_dynamic

echo
echo "*****************************************************************"
echo

#Build FORTRAN test_libarchive
echo "Building test_libarchive_fortran_static..."
gfortran -static -Wall -g test_libarchive.f libArchive_wrapper.o -Llibarchive_build/libarchive/ -larchive -lz -lpthread -o test_libarchive_fortran_static
./test_libarchive_fortran_static C
./test_libarchive_fortran_static L
./test_libarchive_fortran_static R
