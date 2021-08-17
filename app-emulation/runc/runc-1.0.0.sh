#!/bin/sh
source "../../common/init.sh"

MY_PV="${PV/_/-}"
get https://github.com/opencontainers/${PN}/archive/v${MY_PV}.tar.gz
acheck

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
