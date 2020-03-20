#!/bin/sh
source "../../common/init.sh"
inherit asciidoc

get https://www.kernel.org/pub/linux/kernel/people/kdave/${PN}/${PN}-v${PV}.tar.xz
acheck

cd "${PN}-v${PV}"

importpkg dev-libs/lzo sys-apps/util-linux zlib libzstd sys-fs/e2fsprogs

export CFLAGS="${CPPFLAGS} -O2"

doconf

make
make install DESTDIR="${D}"

finalize
