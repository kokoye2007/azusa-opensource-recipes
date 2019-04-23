#!/bin/sh
source "../../common/init.sh"

get ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/${P}.tar.bz2

cd "${T}"

# configure & build
# NOTE: ncurses doesn't support --docdir
doconf

make
make install DESTDIR="${D}"

finalize
