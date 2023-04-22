#!/bin/sh
source "../../common/init.sh"

get https://www.libssh.org/files/${PV%.*}/${P}.tar.xz
acheck

cd "${T}"

importpkg zlib

docmake

finalize
