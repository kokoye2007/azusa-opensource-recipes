#!/bin/sh
source "../../common/init.sh"

get https://github.com/OCL-dev/${PN}/archive/v${PV}.tar.gz ${P}.tar.gz
acheck

# make asciidoc work
ln -snfT /pkg/main/app-text.asciidoc.core/etc/asciidoc /etc/asciidoc

cd "${S}"
aautoreconf

cd "${T}"

doconf --enable-pthread-once

make
make install DESTDIR="${D}"

finalize
