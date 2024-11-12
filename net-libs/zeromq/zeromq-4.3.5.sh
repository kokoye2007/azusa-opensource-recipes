#!/bin/sh
source "../../common/init.sh"

get https://github.com/zeromq/libzmq/releases/download/v"${PV}"/"${P}".tar.gz
acheck

importpkg app-crypt/libmd

cd "${S}" || exit
sed \
	-e '/libzmq_werror=/s:yes:no:g' \
	-i configure.ac

aautoreconf

cd "${T}" || exit

doconf --enable-shared --without-pgm --enable-drafts --enable-libbsd --enable-static --enable-libunwind --with-libsodium --with-docs

make
make install DESTDIR="${D}"

finalize
