#!/bin/sh
source "../../common/init.sh"

importpkg dev-libs/boost

get https://github.com/ethereum/solidity/releases/download/v${PV}/solidity_${PV}.tar.gz
acheck

cd "${T}"

docmake

finalize
