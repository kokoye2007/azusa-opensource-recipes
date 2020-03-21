#/bin/sh
source "../../common/init.sh"

get http://zlib.net/${P}.tar.gz
acheck

cd "${T}"

# configure & build
callconf --prefix=/pkg/main/${PKG}.core.${PVRF} --libdir=/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX
make
make install DESTDIR=${D}

finalize
