#!/bin/sh
source "../../common/init.sh"

get https://github.com/google/${PN}/archive/v${PV}.tar.gz

cd "${T}"

docmake

make
make install DESTDIR="${D}"

finalize
