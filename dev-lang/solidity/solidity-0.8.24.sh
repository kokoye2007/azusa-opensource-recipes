#!/bin/sh
source "../../common/init.sh"

COMMIT_HASH="d9974bed7134e043f7ccc593c0c19c67d2d45dc4"
JSONCPP_VERSION="1.9.3" # solidity depends on an exact version of jsoncpp for some reason
get https://github.com/ethereum/solidity/archive/refs/tags/v${PV}.tar.gz "${P}.tar.gz"
acheck

cd "${S}"

# configure for release version
echo "$COMMIT_HASH" >commit_hash.txt
echo -n >prerelease.txt

# prevent solidity from trying to download third party software
echo 'find_package(fmt REQUIRED)' >cmake/fmtlib.cmake
echo 'find_package(jsoncpp REQUIRED)' >cmake/jsoncpp.cmake
echo 'find_package(range-v3 REQUIRED)' >cmake/range-v3.cmake

# force SOVERSION on libs to ensure a given solc uses the right libs
for foo in evmasm langutil smtutil libsolc solidity solutil yul; do
	if [ -d lib$foo ]; then
		echo "set_target_properties($foo PROPERTIES VERSION $PV SOVERSION $PV)" >>lib$foo/CMakeLists.txt
	else
		echo "set_target_properties($foo PROPERTIES VERSION $PV SOVERSION $PV)" >>$foo/CMakeLists.txt
	fi
done
echo "set_target_properties(phaser PROPERTIES VERSION $PV SOVERSION $PV)" >>tools/CMakeLists.txt
echo "set_target_properties(solcli PROPERTIES VERSION $PV SOVERSION $PV)" >>solc/CMakeLists.txt

cd "${T}"

# ensure solidity can find z3
importpkg sci-mathematics/z3

export CPPFLAGS="$CPPFLAGS -I/pkg/main/dev-libs.jsoncpp.dev.$JSONCPP_VERSION/include/jsoncpp"
export LDFLAGS="$LDFLAGS -L/pkg/main/dev-libs.jsoncpp.libs.$JSONCPP_VERSION/lib$LIB_SUFFIX"

CMAKEOPTS=(
	-DUSE_CVC4=OFF
	-DTESTS=OFF
	-DBUILD_SHARED_LIBS=ON

	-Djsoncpp_ROOT=/pkg/main/dev-libs.jsoncpp.dev.$JSONCPP_VERSION

	-DBoost_ROOT=/pkg/main/dev-libs.boost.dev
	-DBoost_NO_WARN_NEW_VERSIONS=1
	-DBoost_USE_STATIC_LIBS=OFF
)

docmake "${CMAKEOPTS[@]}"

mkdir -p "${D}/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX"
for foo in */*.so.${PV}; do
	cp -v "$foo" "${D}/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX/"
done

finalize
