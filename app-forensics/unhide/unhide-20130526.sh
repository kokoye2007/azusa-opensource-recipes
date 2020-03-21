#!/bin/sh
source "../../common/init.sh"

get http://sourceforge.net/projects/unhide/files/${P}.tgz
acheck

cd "${P}"

echo "Building unhide ..."
gcc --static -pthread unhide-linux*.c unhide-output.c -o unhide
echo "Building unhide-tcp ..."
gcc --static unhide-tcp.c unhide-tcp-fast.c unhide-output.c -o unhide-tcp

mkdir -pv "${D}/pkg/main/${PKG}.core.${PVRF}/bin"
mv -v unhide unhide-tcp "${D}/pkg/main/${PKG}.core.${PVRF}/bin"

mkdir -pv "${D}/pkg/main/${PKG}.doc.${PVRF}/man"
cp -v changelog README.txt TODO LEEME.txt LISEZ-MOI.TXT NEWS "${D}/pkg/main/${PKG}.doc.${PVRF}"
cp -v -r man "${D}/pkg/main/${PKG}.doc.${PVRF}/man/man8"

finalize
