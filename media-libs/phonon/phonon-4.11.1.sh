#!/bin/sh
source "../../common/init.sh"

get http://download.kde.org/stable/phonon/"${PV}"/"${P}".tar.xz
acheck

cd "${T}" || exit

docmake

make
make install DESTDIR="${D}"

finalize
