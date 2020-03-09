#!/bin/sh
source "../../common/init.sh"

get https://github.com/google/${PN}/archive/v${PV}.tar.gz
acheck

cd "${T}"

docmake

make VERBOSE=1
make install DESTDIR="${D}"

finalize
