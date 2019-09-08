#!/bin/sh
source "../../common/init.sh"

get https://github.com/thkukuk/libnsl/archive/v${PV}.tar.gz

cd "${P}"

echo "Running automake/autoconf..."
libtoolize --install
aclocal-1.13
automake-1.13 --add-missing
autoconf

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
