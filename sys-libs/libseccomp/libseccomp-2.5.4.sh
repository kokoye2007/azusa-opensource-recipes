#!/bin/sh
source "../../common/init.sh"

get https://github.com/seccomp/libseccomp/releases/download/v"${PV}"/"${P}".tar.gz
acheck

cd "${T}" || exit

doconf

make
make install DESTDIR="${D}"

finalize
