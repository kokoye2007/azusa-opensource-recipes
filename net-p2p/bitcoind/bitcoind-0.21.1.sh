#!/bin/sh
source "../../common/init.sh"

get https://bitcoincore.org/bin/bitcoin-core-${PV}/bitcoin-${PV}.tar.gz
acheck

cd "${T}"

importpkg dev-libs/boost dev-libs/libevent
#importpkg sys-libs/db
# Bitcoin needs db-4.8
export CPPFLAGS="$CPPFLAGS -I/pkg/main/sys-libs.db.dev.4.8/include"
export LDFLAGS="$LDFLAGS -L/pkg/main/sys-libs.db.libs.4.8/lib$LIB_SUFFIX"

doconf --with-boost-libdir="/pkg/main/dev-libs.boost.libs/lib$LIB_SUFFIX" --enable-asm --without-qtdbus --without-qrencode --enable-wallet --with-daemon --disable-bench --without-libs --without-gui --without-rapidcheck --disable-fuzz --disable-ccache --disable-static --with-system-libsecp256k1 --with-system-univalue
#--with-miniupnpc --enable-upnp-default --enable-zmq --disable-util-cli --disable-util-tx --disable-util-wallet

make -j"$NPROC"
make install DESTDIR="${D}"

finalize
