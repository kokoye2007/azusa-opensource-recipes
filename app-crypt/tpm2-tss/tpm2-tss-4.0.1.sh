#!/bin/sh
source "../../common/init.sh"

get https://github.com/tpm2-software/${PN}/releases/download/${PV}/${P}.tar.gz
acheck

cd "${T}"

importpkg sys-apps/util-linux dev-libs/openssl

doconf --localstatedir=/var --enable-fapi --enable-policy --disable-tcti-libtpms --disable-defaultflags --disable-weakcrypto --with-runstatedir=/run --with-udevrulesprefix=60- --without-sysusersdir

make
make install DESTDIR="${D}"

finalize
