#!/bin/sh
source "../../common/init.sh"

get https://miniupnp.tuxfamily.org/files/${P}.tar.gz
acheck

cd "${T}"

docmake

finalize
