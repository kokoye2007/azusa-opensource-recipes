#!/bin/sh
source "../../common/init.sh"

MY_PV="${PV/_*/}"
get https://ftp.gnu.org/gnu/${PN}/${PN}-${MY_PV}.tar.gz

cd "${PN}-${MY_PV}"

for foo in `seq -f '%03.f' 1 "${PV/*_p/}"`; do
	get https://ftp.gnu.org/gnu/readline/${PN}-${MY_PV}-patches/readline81-$foo
	patch -p0 <"readline81-$foo"
done

acheck

cd "${T}"

importpkg ncursesw

# configure & build
doconf --disable-static --with-curses

make SHLIB_LIBS="-lncursesw"
make install DESTDIR="${D}" SHLIB_LIBS="-lncursesw"

# pkg/main/sys-libs.readline.libs.8.0/lib64/pkgconfig
sed -i -e '/^Requires.private:/d' "${D}/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX/pkgconfig/readline.pc"

finalize
