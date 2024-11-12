#!/bin/sh
source "../../common/init.sh"

get https://github.com/tdf/"${PN}"/archive/v"${PV}".tar.gz "${P}".tar.gz
acheck

cd "${S}" || exit

aautoreconf

cd "${T}" || exit

importpkg dev-libs/boost

# TODO docbook-to-man required for --with-man
doconf --program-suffix=-"${PV%.*}" --disable-werror --without-man --disable-static --enable-client

make -j"$NPROC"
make install DESTDIR="${D}"

finalize
