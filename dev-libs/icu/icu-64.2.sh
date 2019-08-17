#!/bin/sh
source "../../common/init.sh"

get https://github.com/unicode-org/icu/releases/download/release-64-2/icu4c-64_2-src.tgz

cd "icu/source"

doconf

make
make install DESTDIR="${D}"

finalize
