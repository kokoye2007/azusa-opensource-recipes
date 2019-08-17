#!/bin/sh
source "../../common/init.sh"

get https://cache.ruby-lang.org/pub/ruby/2.6/${P}.tar.gz

cd "${T}"

# configure & build
doconf

make
make install DESTDIR="${D}"

finalize
