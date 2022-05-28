#!/bin/sh
source "../../common/init.sh"

get https://github.com/AgentD/${PN}/archive/refs/tags/v${PV}.tar.gz ${P}.tar.gz
acheck

cd "${S}"

aautoreconf

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
