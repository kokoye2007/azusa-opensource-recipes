#!/bin/sh
source "../../common/init.sh"

get https://github.com/PJK/"${PN}"/archive/refs/tags/v"${PV}".tar.gz
acheck

cd "${T}" || exit

docmake -G Ninja

ninja
DESTDIR="${D}" ninja install

finalize
