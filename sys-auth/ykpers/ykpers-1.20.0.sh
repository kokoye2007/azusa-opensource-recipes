#!/bin/sh
source "../../common/init.sh"
inherit asciidoc

get https://github.com/Yubico/yubikey-personalization/archive/v${PV}.tar.gz ${P}.tar.gz
acheck

importpkg sys-auth/libyubikey

cd "${S}"

aautoreconf

cd "${T}"

doconf --disable-static

make
make install DESTDIR="${D}"

finalize
