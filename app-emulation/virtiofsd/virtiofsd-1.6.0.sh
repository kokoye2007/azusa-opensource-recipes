#!/bin/sh
source "../../common/init.sh"

get https://gitlab.com/virtio-fs/virtiofsd/-/archive/v"${PV}"/"${PN}"-v"${PV}".tar.gz "${P}".tar.gz
#acheck
envcheck # cargo requires network access, need to find a way to fix that

importpkg sys-libs/libseccomp sys-libs/libcap-ng

cd "${S}" || exit

export RUSTFLAGS="$LDFLAGS"

cargo build --locked --release

mkdir -pv "${D}/pkg/main/${PKG}.core.${PVRF}/bin"
mv -v target/release/virtiofsd "${D}/pkg/main/${PKG}.core.${PVRF}/bin"

finalize
