#!/bin/sh
source "../../common/init.sh"

get http://www.fftw.org/${P}.tar.gz
acheck

cd "${T}"
mkdir fftw3 fftw3f fftw3l

cd "${T}/fftw3"
doconf --enable-shared --enable-threads --enable-sse2 --enable-avx
make
make install DESTDIR="${D}"

cd "${T}/fftw3f"
doconf --enable-shared --enable-threads --enable-sse2 --enable-avx --enable-float
make
make install DESTDIR="${D}"

cd "${T}/fftw3l"
doconf --enable-shared --enable-threads --enable-long-double
make
make install DESTDIR="${D}"

finalize
