#!/bin/sh
source "../../common/init.sh"

if [ `id -u` -neq 0 ]; then
	echo "This needs to be compiled as root because reasons"
	exit 1
fi

get https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v2.34/${P}.tar.xz

cd "${T}"

doconf --disable-chfn-chsh --disable-login --disable-nologin --disable-su --disable-setpriv --disable-runuser --disable-pylibmount --disable-static --without-python --without-systemd --without-systemdsystemunitdir

make
make install DESTDIR="${D}"

# fix location of some files
mv -v "${D}/pkg/main/${PKG}.core.${PVR}/pkg/main/${PKG}.libs.${PVR}/lib$LIB_SUFFIX/"* "${D}/pkg/main/${PKG}.libs.${PVR}/lib$LIB_SUFFIX"
rm -frv "${D}/pkg/main/${PKG}.core.${PVR}/pkg"

finalize
