#!/bin/sh
source "../../common/init.sh"

get https://github.com/fribidi/fribidi/releases/download/v${PV}/${P}.tar.xz
acheck

cd "${T}"

domeson

finalize
