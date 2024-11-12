#!/bin/sh
source "../../common/init.sh"

get https://github.com/keepassxreboot/keepassxc/archive/"${PV/_/-}".tar.gz "${P}".tar.gz
acheck

cd "${T}" || exit

importpkg sys-auth/libyubikey sys-auth/ykpers media-gfx/qrencode dev-libs/libgpg-error dev-libs/libgcrypt app-crypt/argon2 sys-libs/zlib

docmake -DWITH_GUI_TESTS=OFF -DWITH_TESTS=OFF -DWITH_XC_AUTOTYPE=ON -DWITH_XC_BROWSER=ON -DWITH_XC_FDOSECRETS=ON -DWITH_XC_KEESHARE=OFF -DWITH_XC_NETWORKING=OFF -DWITH_XC_SSHAGENT=ON -DWITH_XC_UPDATECHECK=OFF -DWITH_XC_YUBIKEY=ON

make
make install DESTDIR="${D}"

finalize
