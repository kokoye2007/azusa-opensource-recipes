#!/bin/sh
source "../../common/init.sh"

get https://github.com/linux-pam/linux-pam/releases/download/v"${PV}"/Linux-PAM-"${PV}".tar.xz
acheck

importpkg sys-libs/libxcrypt

cd "${T}" || exit

export TIRPC_CFLAGS="-I/pkg/main/net-libs.libtirpc.dev/include/tirpc"

# configure & build
doconf --enable-securedir="/pkg/main/${PKG}.libs.${PVRF}/security"

make
make install DESTDIR="${D}"

#mv sbin pkg/main/${PKG}.core.${PVRF}

# typically PAM includes are in a "security" folder, link it so it works
ln -s . "${D}/pkg/main/${PKG}.dev.${PVRF}/include/security"

finalize
