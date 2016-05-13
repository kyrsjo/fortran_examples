#! /usr/bin/env bash

rm -rf libarchive_build
mkdir libarchive_build
cd libarchive_build

#cmake ../libarchive
cmake -DENABLE_BZip2=OFF -DENABLE_CAT=OFF -DENABLE_CPIO=OFF -DENABLE_EXPAT=OFF -DENABLE_INSTALL=OFF -DENABLE_LIBXML2=OFF -DENABLE_LZMA=OFF -DENABLE_NETTLE=OFF -DENABLE_OPENSSL=OFF -DENABLE_TAR=OFF ../libarchive
make -j4
make -j4 test
