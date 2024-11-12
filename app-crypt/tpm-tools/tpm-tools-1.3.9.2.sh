#!/bin/sh
source "../../common/init.sh"

get https://download.sourceforge.net/trousers/"${PN}"/"${P}".tar.gz
acheck

importpkg app-crypt/trousers openssl

cd "${S}" || exit

aautoreconf -I .

cd "${T}" || exit

# TODO enable-nls cause an issue with building
doconf --disable-nls

make
make install DESTDIR="${D}"

finalize
