#!/bin/sh
source "../../common/init.sh"

get https://github.com/ethereum/solidity/archive/refs/tags/v${PV}.tar.gz "${P}.tar.gz"
acheck

cd "${S}"

# prevent solidity from trying to download third party software
echo 'find_package(fmt REQUIRED)' >cmake/fmtlib.cmake
echo 'find_package(jsoncpp REQUIRED)' >cmake/jsoncpp.cmake
echo 'find_package(range-v3 REQUIRED)' >cmake/range-v3.cmake
echo 'd9974bed7134e043f7ccc593c0c19c67d2d45dc4' >commit_hash.txt
echo -n >prerelease.txt

cd "${T}"

importpkg sci-mathematics/z3

export CPPFLAGS="$CPPFLAGS -I/pkg/main/dev-libs.jsoncpp.dev.1.9.3/include/jsoncpp"
export LDFLAGS="$LDFLAGS -L/pkg/main/dev-libs.jsoncpp.libs.1.9.3/lib$LIB_SUFFIX"

CMAKEOPTS=(
	-DUSE_CVC4=OFF
	-DTESTS=OFF

	-Djsoncpp_ROOT=/pkg/main/dev-libs.jsoncpp.dev.1.9.3

	-DBoost_NO_WARN_NEW_VERSIONS=1
	-DBoost_USE_STATIC_LIBS=OFF
	-DBOOST_ROOT=/pkg/main/dev-libs.boost.dev
	-DBOOST_INCLUDEDIR=/pkg/main/dev-libs.boost.dev/include/boost
	-DBOOST_LIBRARYDIR=/pkg/main/dev-libs.boost.libs/lib$LIB_SUFFIX
	-DBoost_NO_SYSTEM_PATHS=ON
)

docmake "${CMAKEOPTS[@]}"

mkdir -p "${D}/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX"
for foo in */*.so; do
	tgt="$(basename "$foo")"
	cp -v "$foo" "${D}/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX/$tgt.${PV}"
done

finalize
