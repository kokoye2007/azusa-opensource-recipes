#!/bin/sh
source "../../common/init.sh"

get https://github.com/asciidoc-py/asciidoc-py/releases/download/${PV}/${P}.tar.gz
acheck

cd "${P}"

doconf

make
make install docs DESTDIR="${D}"

finalize
