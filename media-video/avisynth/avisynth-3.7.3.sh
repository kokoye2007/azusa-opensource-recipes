#!/bin/sh
source "../../common/init.sh"

get https://github.com/AviSynth/AviSynthPlus/archive/refs/tags/v"${PV}".tar.gz "${P}.tar.gz"
acheck

cd "${T}" || exit

importpkg media-libs/devil

docmake -G Ninja

ninja
DESTDIR="${D}" ninja install

finalize
