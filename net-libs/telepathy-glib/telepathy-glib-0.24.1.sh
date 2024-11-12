#!/bin/sh
source "../../common/init.sh"

get https://telepathy.freedesktop.org/releases/telepathy-glib/"${P}".tar.gz

cd "${T}" || exit

doconf --enable-vala-bindings --disable-static

make
make install DESTDIR="${D}"

finalize
