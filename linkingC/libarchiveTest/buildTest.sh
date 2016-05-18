#! /usr/bin/env bash

if [ ! -d libarchive_build ]; then
    echo "LibArchive not found, building.."
    ./buildLibArchive.sh
else
    echo "LibArchive already exists"
fi

#Build the wrapper
echo "Building libArchive_wrapper.o..."
gcc -Wall -g -Ilibarchive/libarchive/ -c libArchive_wrapper.c

echo
echo "*****************************************************************"
echo

#Build static libarchive:
echo "Building test_libarchive_static..."
gcc -static -Wall -g test_libarchive.c libArchive_wrapper.o -Ilibarchive/libarchive/ libarchive_build/libarchive/libarchive.a -lz -lpthread -o test_libarchive_static
./test_libarchive_static

echo
echo "*****************************************************************"
echo

#Build dynamic libarchive:
echo "Building test_libarchive_dynamic..."
gcc -Wall -g test_libarchive.c libArchive_wrapper.o -Ilibarchive/libarchive/ -Llibarchive_build/libarchive/ -larchive -lz -o test_libarchive_dynamic
#echo "Done, to run, use"
#echo "LD_LIBRARY_PATH=libarchive_build/libarchive/ ./test_libarchive_dynamic"
LD_LIBRARY_PATH=libarchive_build/libarchive/ ./test_libarchive_dynamic
