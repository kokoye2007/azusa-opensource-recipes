#!/bin/sh
source "../../common/init.sh"

get https://github.com/unicode-org/icu/releases/download/release-${PV//./-}/icu4c-${PV//./_}-src.tgz
acheck

cd "icu/source"

doconf

make
make install DESTDIR="${D}"

finalize
