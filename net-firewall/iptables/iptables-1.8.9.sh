#!/bin/sh
source "../../common/init.sh"

get https://www.netfilter.org/projects/iptables/files/"${P}".tar.xz
acheck

cd "${S}" || exit

rm include/linux/{kernel,types}.h
aautoreconf

cd "${T}" || exit

doconf

make
make install DESTDIR="${D}"

finalize
