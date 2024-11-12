#!/bin/sh
source "../../common/init.sh"

get https://github.com/oneapi-src/oneTBB/archive/refs/tags/v"${PV}".tar.gz "${P}".tar.gz
acheck

cd "${S}" || exit

find include -name \*.html -delete

make -j"$NPROC"

# build/linux_intel64_gcc_cc12.2.0_libc2.36_kernel6.0.5_release/

mkdir -pv "${D}/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX"
cp -arv build/linux_*_release/libtbb* "${D}/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX"

mkdir -pv "${D}/pkg/main/${PKG}.dev.${PVRF}"
cp -rv include "${D}/pkg/main/${PKG}.dev.${PVRF}/include"

finalize
