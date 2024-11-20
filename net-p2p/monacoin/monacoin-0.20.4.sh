#!/bin/sh
source "../../common/init.sh"

get https://github.com/monacoinproject/monacoin/archive/refs/tags/v0.20.4.tar.gz "${P}.tar.gz"
acheck

cd "${S}"

apatch \
	"$FILESDIR/monacoin-0.20.4_gcc14.patch" \
	"$FILESDIR/monacoin-0.20.4_boost_directory_iterator.patch"

aautoreconf

cd "${T}"

importpkg dev-libs/boost dev-libs/libevent sys-libs/db:4.8 libcrypto dev-libs/libfmt net-libs/zeromq

doconf --with-boost-libdir="/pkg/main/dev-libs.boost.libs/lib$LIB_SUFFIX" --enable-asm --without-qtdbus --without-qrencode --enable-wallet --with-daemon --disable-bench --without-libs --without-gui --disable-shared --with-pic --disable-tests --disable-gui-tests
#--enable-asm --without-qtdbus --without-qrencode --enable-wallet --with-daemon --disable-bench --without-libs --without-gui --without-rapidcheck --disable-fuzz --disable-ccache --with-system-univalue
#--with-system-libsecp256k1 --with-system-libsecp256k1-libdir="/pkg/main/dev-libs.libsecp256k1.libs/lib$LIB_SUFFIX"
#--with-miniupnpc --enable-upnp-default --enable-zmq --disable-util-cli --disable-util-tx --disable-util-wallet

make #-j"$NPROC"
make install DESTDIR="${D}"

finalize
