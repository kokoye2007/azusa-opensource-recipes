#!/bin/sh
source "../../common/init.sh"

get https://download.sourceforge.net/${PN}/${P}.tar.gz
acheck

cd "${S}"

make
make install DESTDIR="${D}" prefix="/pkg/main/${PKG}.core.${PVRF}"

finalize
