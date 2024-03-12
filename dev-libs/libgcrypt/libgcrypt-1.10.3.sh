#!/bin/sh
source "../../common/init.sh"

get https://www.gnupg.org/ftp/gcrypt/${PN}/${P}.tar.bz2
acheck

cd "${T}"

doconf

make
make install DESTDIR="${D}"

organize

# fix .pc file
sed -i -e "s,^Libs: ,Libs: -L/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX ," "${D}/pkg/main/${PKG}.dev.${PVRF}/pkgconfig/libgcrypt.pc"
sed -i -e "s,^Cflags: ,Cflags: -I/pkg/main/${PKG}.dev.${PVRF}/include ," "${D}/pkg/main/${PKG}.dev.${PVRF}/pkgconfig/libgcrypt.pc"

fixelf
archive
