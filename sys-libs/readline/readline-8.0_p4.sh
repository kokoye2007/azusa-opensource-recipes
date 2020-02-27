#!/bin/sh
source "../../common/init.sh"

get https://ftp.gnu.org/gnu/${PN}/${PN}-8.0.tar.gz

cd "${PN}-8.0"

for foo in `seq -f '%03.f' 1 4`; do
	get https://ftp.gnu.org/gnu/readline/readline-8.0-patches/readline80-$foo
	patch -p0 <"readline80-$foo"
done

acheck

cd "${T}"

# configure & build
doconf --disable-static

make
make install DESTDIR="${D}"

# pkg/main/sys-libs.readline.libs.8.0/lib64/pkgconfig
sed -i -e '/^Requires.private:/d' "${D}/pkg/main/${PKG}.libs.${PVR}/lib$LIB_SUFFIX/pkgconfig/readline.pc"

finalize
