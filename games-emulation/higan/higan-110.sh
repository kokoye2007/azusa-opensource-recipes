#!/bin/sh
source "../../common/init.sh"

get https://github.com/byuu/higan/archive/v${PV}.tar.gz
acheck

cd "${P}"
cd higan

make platform="linux" hiro=gtk
make install DESTDIR="${D}"

finalize
