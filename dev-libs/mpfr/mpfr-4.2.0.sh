#!/bin/sh
source "../../common/init.sh"

get https://ftp.gnu.org/gnu/"${PN}"/"${P}".tar.xz
acheck

cd "${T}" || exit

# configure & build
doconf --disable-static --enable-thread-safe --with-gmp=$(realpath /pkg/main/dev-libs.gmp.dev)

make
make install DESTDIR="${D}"

finalize
