#!/bin/sh
source "../../common/init.sh"

get https://www.prelude-siem.org/attachments/download/1181/${P}.tar.gz
acheck

cd "${T}"

doconf --enable-easy-bindings --with-swig --without-lua --with-perl-installdirs=vendor --without-ruby --without-python2 --with-python3=/pkg/main/dev-lang.python.core.3/bin/python3

make
make install DESTDIR="${D}"

finalize
