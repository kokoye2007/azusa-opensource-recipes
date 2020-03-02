#!/bin/sh
source "../../common/init.sh"

get https://www2.graphviz.org/Packages/stable/portable_source/${P}.tar.gz
acheck

cd "${P}"

sed -i '/LIBPOSTFIX="64"/s/64//' configure.ac

aautoreconf

cd "${T}"

doconf --with-webp=yes --with-poppler=yes --with-rsvg=yes --with-pangocairo=yes --with-freetype2=yes --with-fontconfig=yes

make
make install DESTDIR="${D}"

# run dot -c to create  /.pkg-main-rw/media-gfx.graphviz.libs.2.42.1.linux.amd64/lib64/graphviz/config6
make install DESTDIR="/"

echo "Running dot -c"
"${D}/pkg/main/${PKG}.core.${PVR}/bin/dot" -c
mkdir -p "${D}/${PKG}.libs.${PVR}/lib$LIB_SUFFIX/graphviz/"
mv -v "/.pkg-main-rw/${PKG}.libs.${PVR}/lib$LIB_SUFFIX/graphviz/config"* "${D}/${PKG}.libs.${PVR}/lib$LIB_SUFFIX/graphviz/"

finalize
