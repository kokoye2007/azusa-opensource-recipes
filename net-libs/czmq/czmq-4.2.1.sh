#!/bin/sh
source "../../common/init.sh"

get https://github.com/zeromq/"${PN}"/releases/download/v"${PV}"/"${P}".tar.gz
acheck

cd "${T}" || exit

doconf --with-docs=no --with-uuid --with-libcurl --with-libmicrohttpd --with-liblz4 --with-nss

make
make install DESTDIR="${D}"

finalize
