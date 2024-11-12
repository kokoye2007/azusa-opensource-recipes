#!/bin/sh
source "../../common/init.sh"

get http://download.savannah.nongnu.org/releases/acl/"${P}".tar.gz
acheck

echo "Compiling ${P} ..."
cd "${T}" || exit

importpkg sys-apps/attr

# configure & build
doconf

make
make install DESTDIR="${D}"

finalize
