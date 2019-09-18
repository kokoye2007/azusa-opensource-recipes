#!/bin/sh
source "../../common/init.sh"

get https://downloads.sourceforge.net/asciidoc/${P}.tar.gz

cd "${T}"

doconf --sysconfdir=/etc

make
make install DESTDIR="${D}"

finalize
