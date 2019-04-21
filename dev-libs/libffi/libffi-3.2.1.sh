#!/bin/sh
source "../../common/init.sh"

get ftp://sourceware.org/pub/libffi/${P}.tar.gz

cd "${P}"

sed -e '/^includesdir/ s/$(libdir).*$/$(includedir)/' \
 -i include/Makefile.in
sed -e '/^includedir/ s/=.*$/=@includedir@/' \
 -e 's/^Cflags: -I${includedir}/Cflags:/' \
 -i libffi.pc.in

cd "${T}"

doconf --disable-static --with-gcc-arch=native

make
make install DESTDIR="${D}"

finalize
