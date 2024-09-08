#!/bin/sh
source "../../common/init.sh"

get https://gitlab.com/bitcoin-cash-node/bitcoin-cash-node/-/archive/v${PV}/bitcoin-cash-node-v${PV}.tar.bz2
acheck

cd "${S}"

apatch \
	"$FILESDIR/bitcoin-cash-node-boost-path.patch" \
	"$FILESDIR/bitcoin-cash-node-27.1.0-gcc14-move.patch" \
	"$FILESDIR/bitcoin-cash-node-27.1.0-miniupnpc-18-fix.patch"

cd "${T}"

importpkg dev-libs/boost dev-libs/libevent sys-libs/db:5.3 net-libs/miniupnpc net-libs/zeromq

docmake -DBUILD_BITCOIN_QT=OFF -DBoost_ROOT=/pkg/main/dev-libs.boost.dev

finalize
