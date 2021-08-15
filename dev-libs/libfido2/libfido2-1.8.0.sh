#!/bin/sh
source "../../common/init.sh"

get https://github.com/Yubico/${PN}/archive/${PV}.tar.gz
acheck

cd "${T}"

importpkg dev-libs/libcbor

docmake -G Ninja -DUSE_NFC=YES

ninja
DESTDIR="${D}" ninja install

finalize
