#!/bin/sh
source "../../common/init.sh"

get https://github.com/htacg/tidy-html5/archive/${PV}/${P}.tar.gz

cd "${T}"

cmake -DCMAKE_INSTALL_PREFIX="/pkg/main/${PKG}.core.${PVRF}" -DCMAKE_BUILD_TYPE=Release -DBUILD_TAB2SPACE=ON "${CHPATH}/${P}"

make
make install DESTDIR="${D}"
install -v -m755 tab2space "${D}/pkg/main/${PKG}.core.${PVRF}/bin"

finalize
