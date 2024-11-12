#!/bin/sh
source "../../common/init.sh"

get https://libopenraw.freedesktop.org/download/"${P}".tar.bz2

cd "${P}" || exit

sed -i -r '/^\s?testadobesdk/d' exempi/tests/Makefile.am
autoreconf -fiv

cd "${T}" || exit

doconf --disable-static

make
make install DESTDIR="${D}"

finalize
