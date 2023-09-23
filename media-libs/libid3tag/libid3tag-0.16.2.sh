#!/bin/sh
source "../../common/init.sh"

get https://codeberg.org/tenacityteam/libid3tag/archive/${PV}.tar.gz ${P}.codeberg.tar.gz
acheck

cd "${T}"

importpkg zlib

docmake

finalize
