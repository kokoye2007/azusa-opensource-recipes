#!/bin/sh
source "../../common/init.sh"

#get https://pagure.io/volume_key/archive/${P}/volume_key-${P}.tar.gz
get http://releases.pagure.org/"${PN}"/"${P}".tar.xz
acheck

cd "${T}" || exit

importpkg app-crypt/gpgme dev-libs/libgpg-error sys-apps/util-linux

doconf --without-python --with-python3

make
make install DESTDIR="${D}"

finalize
