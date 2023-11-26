#!/bin/sh
source "../../common/init.sh"

get https://github.com/unicode-org/icu/releases/download/release-${PV//./-}/icu4c-${PV//./_}-src.tgz
acheck

S="${S}/source"

cd "${T}"

CC=gcc CXX=g++ doconf --disable-debug --disable-samples --enable-static

make -j"$NPROC" VERBOSE=1
make install DESTDIR="${D}"

# some pkgs (boost) require icu to have lib & include dirs in core, make symlinks
ln -snfT "/pkg/main/${PKG}.libs.${PVRF}/lib" "${D}/pkg/main/${PKG}.core.${PVRF}/lib"
ln -snfT "/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX" "${D}/pkg/main/${PKG}.core.${PVRF}/lib$LIB_SUFFIX"
ln -snfT "/pkg/main/${PKG}.dev.${PVRF}/include" "${D}/pkg/main/${PKG}.core.${PVRF}/include"

# fix header files so that when something is included in C ansi code, it doesn't fail
# often happens with programs linking against libxml2 which itself will include icu, comment style needs to be /* */
sed -rie 's#^([#_0-9a-zA-Z ]*)// *(.*)#\1/* \2 */#' "${D}/pkg/main/${PKG}.dev.${PVRF}/include/unicode"/*.h

finalize
