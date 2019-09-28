#!/bin/sh
source "../../common/init.sh"

get https://github.com/Kitware/CMake/releases/download/v${PV}/${P}.tar.gz
acheck

cd "${T}"

export LibRHash_ROOT=/pkg/main/app-crypt.rhash.dev ZLIB_ROOT=/pkg/main/sys-libs.zlib.dev LibArchive_ROOT=/pkg/main/app-arch.libarchive.dev JsonCpp_ROOT=/pkg/main/dev-libs.jsoncpp.dev LibUV_ROOT=/pkg/main/dev-libs.libuv.dev

# configure & build
if [ -f /bin/cmake ]; then
	docmake -DCMAKE_USE_SYSTEM_BZIP2:BOOL=ON -DCMAKE_USE_SYSTEM_CURL:BOOL=ON -DCMAKE_USE_SYSTEM_EXPAT:BOOL=ON -DCMAKE_USE_SYSTEM_FORM:BOOL=ON -DCMAKE_USE_SYSTEM_JSONCPP:BOOL=ON -DCMAKE_USE_SYSTEM_LIBARCHIVE:BOOL=ON -DCMAKE_USE_SYSTEM_LIBLZMA:BOOL=ON -DCMAKE_USE_SYSTEM_LIBRHASH:BOOL=ON -DCMAKE_USE_SYSTEM_LIBUV:BOOL=ON -DCMAKE_USE_SYSTEM_ZLIB:BOOL=ON -DCMAKE_USE_SYSTEM_ZSTD:BOOL=ON
	# CMake_BUILD_LTO:BOOL=OFF
	# CMake_RUN_CLANG_TIDY:BOOL=OFF
else
	callconf --no-qt-gui --prefix=/pkg/main/${PKG}.core.${PVR} --mandir=/pkg/main/${PKG}.doc.${PVR}/man --docdir=/pkg/main/${PKG}.doc.${PVR}/doc --system-libs
fi

make
make install DESTDIR="${D}"

finalize
