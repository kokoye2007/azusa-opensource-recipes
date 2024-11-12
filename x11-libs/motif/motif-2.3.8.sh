#!/bin/sh
source "../../common/init.sh"

get https://download.sourceforge.net/project/motif/Motif%20"${PV}"%20Source%20Code/"${P}".tar.gz
get https://dev.gentoo.org/~ulm/distfiles/"${P}"-patches-1.tar.xz
acheck

cd "${P}" || exit

apatch ../patch/*.patch
AT_M4DIR=. aautoreconf

cd "${T}" || exit

doconf --with-x --disable-printing --enable-utf8 --enable-jpeg --enable-png --enable-xft

make
make install DESTDIR="${D}"

finalize
