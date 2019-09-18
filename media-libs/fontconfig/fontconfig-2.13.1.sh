#!/bin/sh
source "../../common/init.sh"

get https://www.freedesktop.org/software/fontconfig/release/${P}.tar.bz2

cd "${T}"

export UUID_CFLAGS="-I`realpath /pkg/main/sys-apps.util-linux.dev/include`"
export UUID_LIBS="-L`realpath /pkg/main/sys-apps.util-linux.libs/lib64` -luuid"

doconf

make
make install DESTDIR="${D}"

finalize
