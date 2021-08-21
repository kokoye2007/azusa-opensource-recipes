#!/bin/sh
source "../../common/init.sh"

get https://downloads.sourceforge.net/infozip/zip30.tar.gz
acheck

cd "zip30"

make -f unix/Makefile generic_gcc
make -f unix/Makefile install prefix="${D}/pkg/main/${PKG}.core.${PVRF}"

finalize
