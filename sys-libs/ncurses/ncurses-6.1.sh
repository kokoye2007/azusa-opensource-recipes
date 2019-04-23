#!/bin/sh
source "../../common/init.sh"

get https://invisible-mirror.net/archives/ncurses/${P}.tar.gz

sed -i '/LIBTOOL_INSTALL/d' ncurses-${PVR}/c++/Makefile.in

cd "${T}"

# configure & build
# NOTE: ncurses doesn't support --docdir
${CHPATH}/${P}/configure --prefix=/pkg/main/${PKG}.core.${PVR} --sysconfdir=/etc \
--includedir=/pkg/main/${PKG}.dev.${PVR}/include --libdir=/pkg/main/${PKG}.libs.${PVR}/lib64 --datarootdir=/pkg/main/${PKG}.core.${PVR}/share \
--mandir=/pkg/main/${PKG}.doc.${PVR}/man \
--enable-widec --enable-pc-files --with-shared --without-normal --without-debug


make
make install DESTDIR="${D}"

cd "${D}"

mv usr/share/pkgconfig "pkg/main/${PKG}.dev.${PVR}/"

cd "pkg/main/${PKG}.libs.${PVR}/lib64"
for lib in ncurses form panel menu ; do
	# workaround for bash
	ln -snf lib${lib}w.so lib${lib}.so
	ln -snf lib${lib}w.so.6 lib${lib}.so.6
	#echo "INPUT(-l${lib}w)" > lib${lib}.so
	#echo "INPUT(-l${lib}w)" > lib${lib}.so.6
done

finalize
