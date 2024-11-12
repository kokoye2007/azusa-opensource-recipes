#!/bin/sh
source "../../common/init.sh"

get https://github.com/stedolan/jq/releases/download/"${P}"/"${P}".tar.gz
acheck

cd "${T}" || exit

importpkg oniguruma

doconf --disable-docs --disable-valgrind --disable-maintainer-mode --enable-rpathhack --with-oniguruma=yes

make
make install DESTDIR="${D}"

finalize
