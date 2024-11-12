#!/bin/sh
source "../../common/init.sh"

get https://www.nasm.us/pub/nasm/releasebuilds/"${PV}"/"${P}".tar.bz2
acheck

# starting nasm 2.16(?) out of source compilation is not supported:
# cc1: fatal error: asm/warnings.c: No such file or directory
cd "${S}" || exit

# configure & build
doconf

make
make install DESTDIR="${D}"

finalize
