#!/bin/sh
source "../../common/init.sh"

get https://ftp.gnu.org/gnu/readline/${P}.tar.gz
acheck

cd "${T}"

# configure & build
doconf --disable-static

make
make install DESTDIR="${D}"

# pkg/main/sys-libs.readline.libs.8.0/lib64/pkgconfig
sed -i -e '/^Requires.private:/d' "${D}/pkg/main/${PKG}.libs.${PVR}/lib$LIB_SUFFIX/pkgconfig/readline.pc"

finalize
