#!/bin/sh
source "../../common/init.sh"

get https://github.com/shumatech/BOSSA/archive/refs/tags/"${PV}".tar.gz "${P}.tar.gz"
acheck

cd "${S}" || exit

# requires wxgtk 3.0
export PATH="/pkg/main/x11-libs.wxGTK.core.3.0/bin:$PATH"

importpkg X sys-libs/readline

make VERSION="$PV"

# make install will just create a tar file and not install anything
mkdir -p "${D}/pkg/main/${PKG}.core.${PVRF}/bin"
for foo in bossa bossac bossash; do
	mv -v "bin/$foo" "${D}/pkg/main/${PKG}.core.${PVRF}/bin"
done

finalize
