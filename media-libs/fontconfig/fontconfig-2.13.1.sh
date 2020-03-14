#!/bin/sh
source "../../common/init.sh"

get https://www.freedesktop.org/software/fontconfig/release/${P}.tar.bz2

cd "${T}"

export UUID_CFLAGS="-I/pkg/main/sys-apps.util-linux.dev/include"
export UUID_LIBS="-L/pkg/main/sys-apps.util-linux.libs/lib$LIB_SUFFIX -luuid"

doconf

make
make install DESTDIR="${D}"

finalize
