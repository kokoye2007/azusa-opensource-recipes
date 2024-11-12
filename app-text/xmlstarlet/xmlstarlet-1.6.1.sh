#!/bin/sh
source "../../common/init.sh"

get https://download.sourceforge.net/xmlstar/"${P}".tar.gz
acheck

cd "${S}" || exit

importpkg libxml-2.0 libxslt

doconf --disable-build-docs

make V=1
make install DESTDIR="${D}"

finalize
