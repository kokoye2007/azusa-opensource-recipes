#!/bin/sh
source "../../common/init.sh"

MY_PN=LibRaw
MY_PV="${PV/_b/-B}"
MY_P="${MY_PN}-${MY_PV}"

get https://www.libraw.org/data/${MY_P}.tar.gz
acheck

importpkg libjpeg

cd "${S}"

aautoreconf

cd "${T}"

doconf --disable-static --disable-jasper --disable-examples --enable-jpeg --enable-lcms --enable-openmp

make
make install DESTDIR="${D}"

finalize
