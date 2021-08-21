#!/bin/sh
source "../../common/init.sh"

get "https://downloads.sourceforge.net/infozip/${PN}${PV//./}.tar.gz"
acheck

cd "${S}"

make -f unix/Makefile generic_gcc
make -f unix/Makefile install prefix="${D}/pkg/main/${PKG}.core.${PVRF}"

finalize
