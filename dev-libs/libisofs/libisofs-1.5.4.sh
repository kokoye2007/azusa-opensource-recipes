#!/bin/sh
source "../../common/init.sh"

get http://files.libburnia-project.org/releases/"${P}".tar.gz
acheck

cd "${T}" || exit

doconf

make
make install DESTDIR="${D}"

finalize
