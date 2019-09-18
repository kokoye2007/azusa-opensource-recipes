#!/bin/sh
source "../../common/init.sh"

get https://s3.amazonaws.com/json-c_releases/releases/${P}.tar.gz

cd "${T}"

doconf  --disable-static

make
make install DESTDIR="${D}"

finalize
