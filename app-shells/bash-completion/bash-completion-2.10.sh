#!/bin/sh
source "../../common/init.sh"

get https://github.com/scop/bash-completion/releases/download/${PV}/${P}.tar.xz
acheck

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
