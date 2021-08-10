#!/bin/sh
source "../../common/init.sh"

get https://www.spice-space.org/download/releases/${P}.tar.xz
acheck

cd "${T}"

domeson

ninja
DESTDIR="${D}" ninja install

finalize
