#!/bin/sh
source "../../common/init.sh"

get https://downloads.sourceforge.net/"${PN}"/lcms2-"${PV}".tar.gz
acheck

cd "${S}" || exit

sed -i '/AX_APPEND/s/^/#/' configure.ac
autoreconf

doconf

make
make install DESTDIR="${D}"

finalize
