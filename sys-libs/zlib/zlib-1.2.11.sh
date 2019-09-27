#/bin/sh
source "../../common/init.sh"

get http://zlib.net/${P}.tar.gz
acheck

cd "${T}"

# configure & build
callconf --prefix=/pkg/main/${PKG}.core.${PVR} --libdir=/pkg/main/${PKG}.libs.${PVR}/lib$LIB_SUFFIX
make
make install DESTDIR=${D}

finalize
