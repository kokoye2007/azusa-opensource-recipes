#!/bin/sh
source "../../common/init.sh"

get https://sourceforge.net/projects/psmisc/files/psmisc/psmisc-23.2.tar.xz

cd "${T}"

# configure & build
doconf

make
make install DESTDIR="${D}"

finalize
