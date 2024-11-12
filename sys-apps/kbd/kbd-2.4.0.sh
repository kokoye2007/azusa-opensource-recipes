#!/bin/sh
source "../../common/init.sh"

get https://mirrors.edge.kernel.org/pub/linux/utils/kbd/"${P}".tar.xz
acheck

cd "${T}" || exit

importpkg sys-libs/pam dev-libs/check

doconf

make
make install DESTDIR="${D}"

finalize
