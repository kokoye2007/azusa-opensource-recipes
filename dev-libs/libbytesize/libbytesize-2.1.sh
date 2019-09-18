#!/bin/sh
source "../../common/init.sh"

get https://github.com/storaged-project/libbytesize/releases/download/2.1/${P}.tar.gz

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
