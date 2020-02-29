#!/bin/sh
source "../../common/init.sh"

get https://github.com/Kitware/CMake/releases/download/v${PV}/${P}.tar.gz
acheck

cd "${P}"

apatch "$FILESDIR/cmake-enforce-CMP0074-3.16.4.patch"

cd "${T}"

# configure & build
if [ -f /bin/cmake ]; then
	docmake -DCMAKE_USE_SYSTEM_BZIP2:BOOL=ON -DCMAKE_USE_SYSTEM_CURL:BOOL=ON -DCMAKE_USE_SYSTEM_EXPAT:BOOL=ON -DCMAKE_USE_SYSTEM_FORM:BOOL=ON -DCMAKE_USE_SYSTEM_JSONCPP:BOOL=ON -DCMAKE_USE_SYSTEM_LIBARCHIVE:BOOL=ON -DCMAKE_USE_SYSTEM_LIBLZMA:BOOL=ON -DCMAKE_USE_SYSTEM_LIBRHASH:BOOL=ON -DCMAKE_USE_SYSTEM_LIBUV:BOOL=ON -DCMAKE_USE_SYSTEM_ZLIB:BOOL=ON -DCMAKE_USE_SYSTEM_ZSTD:BOOL=ON
	# CMake_BUILD_LTO:BOOL=OFF
	# CMake_RUN_CLANG_TIDY:BOOL=OFF
else
	cmakeenv
	callconf --no-qt-gui --prefix=/pkg/main/${PKG}.core.${PVR} --mandir=/pkg/main/${PKG}.doc.${PVR}/man --docdir=/pkg/main/${PKG}.doc.${PVR}/doc
fi

make
make install DESTDIR="${D}"

finalize
