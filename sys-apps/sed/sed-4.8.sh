#!/bin/sh
source "../../common/init.sh"

get http://ftp.gnu.org/gnu/sed/"${P}".tar.xz
acheck

cd "${T}" || exit

# configure & build
doconf

make
make install DESTDIR="${D}"

finalize
