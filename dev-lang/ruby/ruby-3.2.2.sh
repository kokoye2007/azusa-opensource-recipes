#!/bin/sh
source "../../common/init.sh"

get https://cache.ruby-lang.org/pub/ruby/"${PV%.*}"/"${P}".tar.gz
acheck

importpkg sys-libs/db sys-libs/gdbm zlib sys-libs/readline ncurses libxcrypt

cd "${T}" || exit

# configure & build
doconf --enable-shared

make -j"$NPROC"
make install DESTDIR="${D}"

finalize
