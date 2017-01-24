#! /usr/bin/env bash

if [ ! -d libarchive_build ]; then
    echo "LibArchive not found, building.."
    ./buildLibArchive.sh
else
    echo "LibArchive already exists"
fi

set -e #Exit on error

set +o verbose +o xtrace #Disable options
echo "Building libArchive_wrapper.o..."
set -o verbose -o xtrace
gcc -Wall -g -Ilibarchive/libarchive/ -c libArchive_wrapper.c
set +o verbose +o xtrace

echo
echo "*****************************************************************"
echo

#Build static test_libarchive:
echo "Building test_libarchive_static..."
set -o verbose -o xtrace
gcc -Wall -g -c test_libarchive.c
if [[ $(uname) == MINGW* ]]; then
    gcc -static -Wall -g test_libarchive.o libArchive_wrapper.o -Llibarchive_build/libarchive/ -larchive -lz -lbz2 -lBcrypt -lpthread -liconv -o test_libarchive_static
else
    gcc -static -Wall -g test_libarchive.o libArchive_wrapper.o -Llibarchive_build/libarchive/ -larchive -lz -lpthread -o test_libarchive_static
fi

./test_libarchive_static

set +o verbose +o xtrace

echo
echo "*****************************************************************"
echo

#Build dynamic test_libarchive:
echo "Building test_libarchive_dynamic..."
set -o verbose -o xtrace
gcc -Wall -g test_libarchive.c libArchive_wrapper.o -Llibarchive_build/libarchive/ -larchive -lz -o test_libarchive_dynamic

#echo "Done, to run, use"
#echo "LD_LIBRARY_PATH=libarchive_build/libarchive/ ./test_libarchive_dynamic"
LD_LIBRARY_PATH=libarchive_build/libarchive/ ./test_libarchive_dynamic

set +o verbose +o xtrace

echo
echo "*****************************************************************"
echo

echo "Building libArchive_Fwrapper.c"
set -o verbose -o xtrace
gcc -Wall -g -c libArchive_Fwrapper.c
set +o verbose +o xtrace

#Build FORTRAN test_libarchive
echo "Building test_libarchive_fortran_static..."
set -o verbose -o xtrace
gfortran -static -Wall -g test_libarchive.f libArchive_Fwrapper.o libArchive_wrapper.o -Llibarchive_build/libarchive/ -larchive -lz -lpthread -o test_libarchive_fortran_static

./test_libarchive_fortran_static W
./test_libarchive_fortran_static L

ls tmpdir
rm tmpdir/README tmpdir/buildTest.sh tmpdir/buildLibArchive.sh
./test_libarchive_fortran_static R
ls tmpdir

set +o verbose +o xtrace
