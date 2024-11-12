#!/bin/sh
source "../../common/init.sh"

get http://ftp.jp.debian.org/debian/pool/main/"${PN:0:1}"/"${PN}"/"${P/-/_}".orig.tar.gz
acheck

cd "${S}" || exit

apatch "$FILESDIR/fakeroot-1.25.3-glibc-2.33.patch"
aautoreconf

cd "${T}" || exit

importpkg sys-libs/libcap

doconf

make

pushd doc || exit
po4a -v -k 0 --variable "srcdir=${S}/doc/" po4a/po4a.cfg
popd || exit

make install DESTDIR="${D}" || /bin/bash -i

finalize
