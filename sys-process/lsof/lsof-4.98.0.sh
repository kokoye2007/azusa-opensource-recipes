#!/bin/sh
source "../../common/init.sh"

get https://github.com/lsof-org/lsof/releases/download/"${PV}"/"${P}".tar.gz
acheck

cd "${S}" || exit

doconf

make
make install DESTDIR="${D}"


finalize
