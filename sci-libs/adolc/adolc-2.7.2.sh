#!/bin/sh
source "../../common/init.sh"

get https://github.com/coin-or/ADOL-C/archive/releases/"${PV}".tar.gz "${P}".tar.gz
acheck

cd "${S}" || exit

apatch "${FILESDIR}/adolc-2.7.2-swig-python-configure.patch"

aautoreconf

doconf --disable-python --disable-static --enable-advanced-branching --enable-atrig-erf --enable-mpi --enable-sparse --with-boost --with-colpack

make
make install DESTDIR="${D}"

finalize
