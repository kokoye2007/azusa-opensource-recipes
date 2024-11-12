#!/bin/sh
source "../../common/init.sh"

get https://archive.apache.org/dist/subversion/"${P}".tar.bz2
acheck

cd "${T}" || exit

importpkg dev-libs/expat uuid net-libs/serf

doconf --disable-static --with-lz4=internal --with-utf8proc=internal

make
make install DESTDIR="${D}"

finalize
