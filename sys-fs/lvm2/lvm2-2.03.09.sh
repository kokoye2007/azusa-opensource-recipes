#!/bin/sh
source "../../common/init.sh"

get http://mirrors.kernel.org/sourceware/lvm2/LVM2.${PV}.tgz
acheck

cd "${T}"

importpkg dev-libs/libaio
export CFLAGS="$CPPFLAGS"

doconf

make
make install DESTDIR="${D}"

# create symlinks
ln -snfv libdevmapper.so.1.02 "${D}/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX/libdevmapper.so.1"
ln -snfv libdevmapper.so.1.02 "${D}/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX/libdevmapper.so"

finalize
