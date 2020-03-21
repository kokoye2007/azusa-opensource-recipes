#!/bin/sh
source "../../common/init.sh"

get ftp://sourceware.org/pub/libffi/${P}.tar.gz
acheck

cd "${P}"

sed -e '/^includesdir/ s/$(libdir).*$/$(includedir)/' \
 -i include/Makefile.in
sed -e '/^includedir/ s/=.*$/=@includedir@/' \
 -i libffi.pc.in

cd "${T}"

doconf --disable-static --with-gcc-arch=native

make
make install DESTDIR="${D}"

if [ $MULTILIB = no ]; then
	# fix libffi lib location
	if [ -d "${D}/pkg/main/${PKG}.libs.${PVRF}/lib64" ]; then
		mv -v "${D}/pkg/main/${PKG}.libs.${PVRF}/lib64"/* "${D}/pkg/main/${PKG}.libs.${PVRF}/lib"
		rmdir "${D}/pkg/main/${PKG}.libs.${PVRF}/lib64"
	fi
fi

finalize
