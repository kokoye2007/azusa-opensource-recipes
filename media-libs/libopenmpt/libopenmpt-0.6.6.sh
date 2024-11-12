#!/bin/sh
source "../../common/init.sh"

MY_P="libopenmpt-${PV}+release.autotools"
get https://lib.openmpt.org/files/libopenmpt/src/"${MY_P}".tar.gz
acheck

importpkg media-libs/alsa-lib

cd "${T}" || exit

doconf

make
make install DESTDIR="${D}"

finalize
