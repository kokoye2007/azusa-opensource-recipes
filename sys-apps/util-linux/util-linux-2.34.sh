#!/bin/sh
cd "$(dirname $0)"
source "../../common/init.sh"

if [ `id -u` -ne 0 ]; then
	echo "This needs to be compiled as root because reasons"
	exit 1
fi

get https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v2.34/${P}.tar.xz

cd "${T}"

# fix linking of pcre2-8
export LDFLAGS="$(pkg-config --libs-only-L libpcre2-8)"

# libdir needs to start with $prefix in order to avoid weird bugs

doconf --libdir=/pkg/main/${PKG}.core.${PVR}/lib$LIB_SUFFIX \
	--disable-chfn-chsh --disable-login --disable-nologin --disable-su --disable-setpriv --disable-runuser --disable-pylibmount --disable-static \
	--without-python --without-systemd --without-systemdsystemunitdir

make
make install DESTDIR="${D}"

finalize
