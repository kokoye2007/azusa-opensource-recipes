#!/bin/sh
source "../../common/init.sh"

get https://github.com/storaged-project/libblockdev/releases/download/${PV}-1/${P}.tar.gz
acheck

cd "${T}"

importpkg dev-libs/volume_key sys-apps/kmod zlib liblzma dev-libs/libbytesize dev-libs/gmp mpfr libpcre2-8 sys-apps/util-linux

export GLIB_CFLAGS="$(pkg-config --cflags glib-2.0) $CPPFLAGS -Wno-attributes"

# lvm2
export DEVMAPPER_CFLAGS="-I/pkg/main/sys-fs.lvm2.dev/include"
export DEVMAPPER_LIBS="-L/pkg/main/sys-fs.lvm2.libs/lib$LIB_SUFFIX -ldevmapper"

doconf --with-python3 --without-gtk-doc --without-nvdimm --without-dm

make
make install DESTDIR="${D}"

finalize
