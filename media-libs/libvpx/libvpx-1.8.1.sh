#!/bin/sh
source "../../common/init.sh"

get https://github.com/webmproject/${PN}/archive/v${PV}.tar.gz

acheck

cd "${T}"

doconflight

make
make install DESTDIR="${D}"

finalize
