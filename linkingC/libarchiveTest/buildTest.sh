#! /usr/bin/env bash

if [ ! -d libarchive_build ]; then
    echo "LibArchive not found, building.."
    ./buildLibArchive.sh
else
    echo "LibArchive already exists"
fi

#Build static libarchive:
gcc -static -Wall -g test_libarchive.c -Ilibarchive/libarchive/ libarchive_build/libarchive/libarchive.a -lz -o test_libarchive_static

#Build dynamic libarchive:
gcc -Wall -g test_libarchive.c -Ilibarchive/libarchive/ -Llibarchive_build/libarchive/ -larchive -lz -o test_libarchive_dynamic
