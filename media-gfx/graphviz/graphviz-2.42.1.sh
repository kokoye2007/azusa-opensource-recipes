#!/bin/sh
source "../../common/init.sh"

get https://www2.graphviz.org/Packages/stable/portable_source/${P}.tar.gz
acheck

cd "${P}"

sed -i '/LIBPOSTFIX="64"/s/64//' configure.ac
rm -frv libltdl # old libtool, do not autoreconf

aautoreconf

cd "${T}"

importpkg expat x11-libs/libXaw zlib media-libs/gd x11-base/xorg-proto x11-libs/libX11 dev-scheme/guile dev-lang/lua x11-libs/cairo dev-libs/libatomic_ops

export CFLAGS="${CPPFLAGS} -O2"

doconf --enable-ltdl --with-x --with-webp=yes --with-poppler=yes --with-rsvg=yes --with-pangocairo=yes --with-freetype2=yes --with-fontconfig=yes --with-digcola --with-freetype2 --with-libgd --with-sfdp --without-ming --with-cgraph --without-glitz --without-ipsepcola --without-smyrna --without-visio --disable-go --disable-io --disable-lua --disable-ocaml --disable-php --disable-python --disable-r --disable-sharp --without-included-ltdl --disable-ltdl-install

make
make install DESTDIR="${D}"

# run dot -c to create  /.pkg-main-rw/media-gfx.graphviz.libs.2.42.1.linux.amd64/lib64/graphviz/config6
make install DESTDIR="/"

echo "Running dot -c"
"${D}/pkg/main/${PKG}.core.${PVR}/bin/dot" -c
mkdir -p "${D}/${PKG}.libs.${PVR}/lib$LIB_SUFFIX/graphviz/"
mv -v "/.pkg-main-rw/${PKG}.libs.${PVR}/lib$LIB_SUFFIX/graphviz/config"* "${D}/${PKG}.libs.${PVR}/lib$LIB_SUFFIX/graphviz/"

finalize
