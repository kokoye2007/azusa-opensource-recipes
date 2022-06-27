#!/bin/sh
source "../../common/init.sh"

MAJOR_P="${PV%.*}"
MY_P="${PN}-${PV/_p/-patch}"
get https://www.hdfgroup.org/ftp/HDF5/releases/${PN}-${MAJOR_P}/${MY_P}/src/${MY_P}.tar.bz2
acheck

cd "${T}"

#importpkg sys-cluster/openmpi
# --enable-parallel

doconf --disable-static --enable-deprecated-symbols --enable-build-mode=production --enable-cxx --enable-hl --disable-parallel --enable-threadsafe --enable-unsupported --with-szlib --with-pthread --with-zlib

make
make install DESTDIR="${D}"

finalize
