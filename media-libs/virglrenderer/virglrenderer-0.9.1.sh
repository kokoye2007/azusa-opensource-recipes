#!/bin/sh
source "../../common/init.sh"

get https://gitlab.freedesktop.org/virgl/${PN}/-/archive/${P}/${PN}-${P}.tar.gz
acheck

cd "${T}"

domeson

ninja
DESTDIR="${D}" ninja install

finalize
