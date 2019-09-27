#!/bin/sh
source "../../common/init.sh"

get https://download.sourceforge.net/${PN}/${P}-src.tar.gz
acheck

cd */

doconflight

make
make install DESTDIR="${D}"

finalize
