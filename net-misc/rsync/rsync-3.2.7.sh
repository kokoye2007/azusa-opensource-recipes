#!/bin/sh
source "../../common/init.sh"

get https://download.samba.org/pub/rsync/"${P}".tar.gz
acheck

importpkg openssl libzstd liblz4 libxxhash

cd "${T}" || exit

doconf

make
make install DESTDIR="${D}"

finalize
