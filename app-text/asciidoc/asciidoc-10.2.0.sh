#!/bin/sh
source "../../common/init.sh"
inherit python

get https://github.com/asciidoc-py/asciidoc-py/releases/download/${PV}/${P}.tar.gz
acheck

cd "${S}"

aautoreconf

doconf

make
make install docs DESTDIR="${D}"

pythonsetup

finalize
