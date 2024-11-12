#!/bin/sh
source "../../common/init.sh"

get https://www.freedesktop.org/software/desktop-file-utils/releases/"${P}".tar.xz

cd "${T}" || exit

doconf

make
make install DESTDIR="${D}"

finalize
