#!/bin/sh
source "../../common/init.sh"

get https://download.sourceforge.net/hunspell/"${P}".tar.gz
acheck

cd "${T}" || exit

doconf

make
make install DESTDIR="${D}"

finalize
