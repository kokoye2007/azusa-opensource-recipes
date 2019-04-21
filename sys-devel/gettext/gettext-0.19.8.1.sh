#!/bin/sh
source "../../common/init.sh"

get http://ftp.gnu.org/pub/gnu/${PN}/${P}.tar.gz

cd "${P}"

# fix stuff
sed -i '/^TESTS =/d' gettext-runtime/tests/Makefile.in &&
sed -i 's/test-lock..EXEEXT.//' gettext-tools/gnulib-tests/Makefile.in

sed -e '/AppData/{N;N;p;s/\.appdata\./.metainfo./}' \
 -i gettext-tools/its/appdata.loc

cd "${T}"

doconf --disable-static

make >make.log 2>&1
make >make_install.log 2>&1 install DESTDIR="${D}"

finalize
