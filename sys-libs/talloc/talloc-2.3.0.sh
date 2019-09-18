#!/bin/sh
source "../../common/init.sh"

get https://www.samba.org/ftp/talloc/${P}.tar.gz

cd "${P}"

doconf

make
make install DESTDIR="${D}"

finalize
