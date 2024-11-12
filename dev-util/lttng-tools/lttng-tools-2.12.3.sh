#!/bin/sh
source "../../common/init.sh"

get https://lttng.org/files/"${PN}"/"${P}".tar.bz2
acheck

inherit asciidoc

cd "${T}" || exit

importpkg dev-libs/userspace-rcu sys-apps/kmod dev-libs/popt

# TODO fix man pages
doconf --disable-man-pages

make V=1
make install DESTDIR="${D}"

finalize
