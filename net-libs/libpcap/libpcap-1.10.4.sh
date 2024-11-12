#!/bin/sh
source "../../common/init.sh"

get https://github.com/the-tcpdump-group/"${PN}"/archive/"${P/_}".tar.gz
acheck

cd "${T}" || exit

doconf

make
make install DESTDIR="${D}"

finalize
