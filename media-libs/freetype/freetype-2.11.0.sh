#!/bin/sh
source "../../common/init.sh"

get https://download.savannah.gnu.org/releases/freetype/${P}.tar.xz
acheck

cd "${P}"

sed -ri "s:.*(AUX_MODULES.*valid):\1:" modules.cfg
sed -r "s:.*(#.*SUBPIXEL_RENDERING) .*:\1:" -i include/freetype/config/ftoption.h

cd "${T}"

importpkg app-arch/bzip2

# force harfbuzz to yes so we get an error if it is not detected
doconf --enable-freetype-config --disable-static --with-zlib=yes --with-bzip2=yes --with-png=yes --with-harfbuzz=yes

make
make install DESTDIR="${D}"

finalize
