#!/bin/sh
source "../../common/init.sh"

get https://github.com/linux-pam/linux-pam/releases/download/v${PV}/Linux-PAM-${PV}.tar.xz

echo "Compiling Linux-PAM-${PV} ..."
cd "${T}"

export TIRPC_CFLAGS="-I/pkg/main/net-libs.libtirpc.dev/include/tirpc"

# configure & build
doconf --enable-securedir=/etc/security

make
make install DESTDIR="${D}"

cd "${D}"

mv etc pkg/main/${PKG}.core.${PVR}
mv sbin pkg/main/${PKG}.core.${PVR}

finalize
