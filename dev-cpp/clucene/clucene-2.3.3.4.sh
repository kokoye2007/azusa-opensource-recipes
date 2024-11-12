#!/bin/sh
source "../../common/init.sh"

get https://downloads.sourceforge.net/clucene/clucene-core-"${PV}".tar.gz
acheck

cd "${S}" || exit

apatch "$FILESDIR/clucene-2.3.3.4-contribs_lib-1.patch"

cd "${T}" || exit

docmake -DBUILD_CONTRIBS_LIB=ON

make
make install DESTDIR="${D}"

finalize
