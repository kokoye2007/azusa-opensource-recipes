#!/bin/sh
source "../../common/init.sh"

get https://github.com/Kitware/CMake/releases/download/v${PV}/${P}.tar.gz
acheck

cd "${S}"

apatch "$FILESDIR/${P}-use-absolute-paths.patch"

importpkg app-crypt/rhash sys-libs/zlib app-arch/libarchive dev-libs/libuv net-misc/curl

CMAKEOPTS=(
	-DCMAKE_USE_SYSTEM_BZIP2:BOOL=ON
	-DCMAKE_USE_SYSTEM_CURL:BOOL=ON
	-DCMAKE_USE_SYSTEM_EXPAT:BOOL=ON
	-DCMAKE_USE_SYSTEM_FORM:BOOL=ON
	-DCMAKE_USE_SYSTEM_LIBARCHIVE:BOOL=ON
	-DCMAKE_USE_SYSTEM_LIBLZMA:BOOL=ON
	-DCMAKE_USE_SYSTEM_LIBRHASH:BOOL=ON
	-DCMAKE_USE_SYSTEM_LIBUV:BOOL=ON
	-DCMAKE_USE_SYSTEM_ZLIB:BOOL=ON
)

# jsoncpp and zstd depend on cmake, so might not be installed when we're building cmake
if [ -d /pkg/main/dev-libs.jsoncpp.core ]; then
	importpkg dev-libs/jsoncpp
	CMAKEOPTS+=(-DCMAKE_USE_SYSTEM_JSONCPP:BOOL=ON)
fi
if [ -d /pkg/main/app-arch.zstd.core ]; then
	CMAKEOPTS+=(-DCMAKE_USE_SYSTEM_ZSTD:BOOL=ON)
fi

cd "${T}"

# configure & build
if [ -f /bin/cmake ]; then
	docmake "${CMAKEOPTS[@]}"
	# CMake_BUILD_LTO:BOOL=OFF
	# CMake_RUN_CLANG_TIDY:BOOL=OFF
else
	callconf --no-qt-gui --prefix=/pkg/main/${PKG}.core.${PVRF} --mandir=/pkg/main/${PKG}.doc.${PVRF}/man --docdir=/pkg/main/${PKG}.doc.${PVRF}/doc -- "${CMAKEOPTS[@]}"
	make -j"$NPROC"
	make install DESTDIR="${D}"
fi

finalize
