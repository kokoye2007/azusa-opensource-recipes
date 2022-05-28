#!/bin/sh
source "../../common/init.sh"

get https://www.kernel.org/pub/linux/kernel/people/kdave/${PN}/${PN}-v${PV}.tar.xz
acheck

cd "${S}"

importpkg dev-libs/lzo sys-apps/util-linux zlib libzstd sys-fs/e2fsprogs libudev
inherit asciidoc

export CFLAGS="${CPPFLAGS} -O2"

doconf

make
make install DESTDIR="${D}"

finalize
