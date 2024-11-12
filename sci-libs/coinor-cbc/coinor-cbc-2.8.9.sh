#!/bin/sh
source "../../common/init.sh"

MYPN=Cbc

get http://www.coin-or.org/download/source/${MYPN}/${MYPN}-"${PV}".tgz
acheck

cd "${S}" || exit

sed -i \
	-e "s:lib/pkgconfig:lib$LIB_SUFFIX/pkgconfig:g" \
	configure

doconflight --enable-dependency-linking
# --with-coin-instdir="/pkg/main/${PKG}.core.${PVRF}"

# do not biuld in parallel
#make -C src libCbc.la
#make -C src libCbcSolver.la
make

make install DESTDIR="${D}"

finalize
