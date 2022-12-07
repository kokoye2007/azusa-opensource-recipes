#!/bin/sh
source "../../common/init.sh"

get https://github.com/linuxwacom/${PN}/releases/download/${P}/${P}.tar.xz
acheck

cd "${T}"

domeson

finalize
