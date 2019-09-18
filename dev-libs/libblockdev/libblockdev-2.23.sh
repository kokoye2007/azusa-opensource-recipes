#!/bin/sh
source "../../common/init.sh"

get https://github.com/storaged-project/libblockdev/releases/download/${PV}-1/${P}.tar.gz

cd "${T}"

doconf --with-python3 --without-gtk-doc --without-nvdimm --without-dm

make
make install DESTDIR="${D}"

finalize
