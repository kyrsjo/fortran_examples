#! /usr/bin/env bash

rm -rf libarchive_build
mkdir libarchive_build
cd libarchive_build

cmake ../libarchive
make -j4
make -j4 test
