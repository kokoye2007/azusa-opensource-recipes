#!/bin/sh
source "../../common/init.sh"

get https://downloads.sourceforge.net/asciidoc/${P}.tar.gz

cd "${P}"

doconf --sysconfdir=/etc

make
make install DESTDIR="${D}"

finalize
