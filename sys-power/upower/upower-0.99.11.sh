#!/bin/sh
source "../../common/init.sh"

get https://gitlab.freedesktop.org/upower/upower/uploads/93cfe7c8d66ed486001c4f3f55399b7a/"${P}".tar.xz
acheck

cd "${T}" || exit

doconf --enable-deprecated --disable-static

make
make install DESTDIR="${D}"

finalize
