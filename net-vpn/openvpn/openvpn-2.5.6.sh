#!/bin/sh
source "../../common/init.sh"

get https://build.openvpn.net/downloads/releases/"${P}".tar.gz
acheck

importpkg dev-libs/lzo sys-libs/pam

cd "${T}" || exit

doconf

make
make install DESTDIR="${D}"

finalize
