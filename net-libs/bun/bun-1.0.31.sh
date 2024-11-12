#!/bin/sh
source "../../common/init.sh"

get https://github.com/oven-sh/bun/archive/refs/tags/bun-v"${PV}".tar.gz "${P}.tar.gz"
acheck

cd "${S}" || exit

docmake

finalize
