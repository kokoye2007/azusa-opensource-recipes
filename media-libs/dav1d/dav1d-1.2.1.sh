#!/bin/sh
source "../../common/init.sh"

get https://code.videolan.org/videolan/dav1d/-/archive/"${PV}"/"${P}".tar.bz2
acheck

cd "${T}" || exit

domeson -Dbitdepths="8,16" -Denable_asm=true

ninja
DESTDIR="${D}" ninja install

finalize
