#!/bin/sh
source "../../common/init.sh"

get https://github.com/thkukuk/libnsl/archive/v"${PV}".tar.gz

cd "${P}" || exit

echo "Running automake/autoconf..."
libtoolize --install
aclocal-1.13
automake-1.13 --add-missing
autoconf

cd "${T}" || exit

doconf

make
make install DESTDIR="${D}"

finalize
