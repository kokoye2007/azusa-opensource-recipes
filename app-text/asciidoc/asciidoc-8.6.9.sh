#!/bin/sh
source "../../common/init.sh"

get https://downloads.sourceforge.net/asciidoc/${P}.tar.gz
acheck

cd "${P}"

# change python
sed -e '1 s,^#.*,#/pkg/main/dev-lang.python.core.2.7/bin/python2.7,' -i *.py

doconf

make
make install docs DESTDIR="${D}"

finalize
