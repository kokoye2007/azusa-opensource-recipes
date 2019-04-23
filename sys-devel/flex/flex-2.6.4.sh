#!/bin/sh
source "../../common/init.sh"

get https://github.com/westes/flex/files/981163/${P}.tar.gz
sed -i "/math.h/a #include <malloc.h>" ${P}/src/flexdef.h

cd "${T}"

# configure & build
HELP2MAN=/bin/true doconf

make
make install DESTDIR="${D}"

finalize
