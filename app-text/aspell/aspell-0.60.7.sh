#!/bin/sh
source "../../common/init.sh"

get https://ftp.gnu.org/gnu/aspell/${P}.tar.gz

cd "${T}"

doconf

make
make install DESTDIR="${D}"

cd "${CHPATH}/${P}"
install -v -m 755 scripts/ispell "${D}/pkg/main/${PKG}.core.${PVRF}/bin/"
install -v -m 755 scripts/spell "${D}/pkg/main/${PKG}.core.${PVRF}/bin/"

finalize
