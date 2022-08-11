#!/bin/sh
source "../../common/init.sh"

get https://www.open-mpi.org/software/${PN}/${PV%.*}/downloads/${P}.tar.bz2
acheck

cd "${T}"

importpkg X

doconf --disable-opencl --disable-netloc --disable-plugin-ltdl --enable-plugins --enable-shared --runstatedir=/run --enable-cairo --enable-cpuid --enable-libudev --enable-pci --enable-libxml2 --with-x
# --enable-cuda
# --enable-nvml
# --enable-gl

make
make install DESTDIR="${D}"

finalize
