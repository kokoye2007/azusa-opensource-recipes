#!/bin/sh
source "../../common/init.sh"

get http://www.unbound.net/downloads/"${P}".tar.gz
acheck

cd "${T}" || exit

doconf --sysconfdir=/etc --disable-static --with-pidfile=/var/run/unbound.pid --with-ssl=/pkg/main/dev-libs.openssl.dev --with-libexpat=/pkg/main/dev-libs.expat.dev

make
make install DESTDIR="${D}"

finalize
