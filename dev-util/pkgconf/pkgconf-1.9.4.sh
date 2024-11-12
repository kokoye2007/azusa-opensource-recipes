#!/bin/sh
source "../../common/init.sh"

get https://distfiles.dereferenced.org/"${PN}"/"${P}".tar.xz
acheck

cd "${T}" || exit

doconf --with-pkg-config-dir=/pkg/main/azusa.symlinks.core/lib/pkgconfig/

make
make install DESTDIR="${D}"

finalize
