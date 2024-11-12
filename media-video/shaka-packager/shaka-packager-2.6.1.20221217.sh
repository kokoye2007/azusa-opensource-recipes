#!/bin/sh
source "../../common/init.sh"

if [ "${PV}" != "2.6.1.20221217" ]; then
	die "revision update needed"
fi

#get https://github.com/shaka-project/shaka-packager/archive/refs/tags/v${PV}.tar.gz ${P}.tar.gz
#gclient config https://github.com/shaka-project/shaka-packager.git --name=src --unmanaged
#gclient sync -r d5ca6e84e6ccd543dc9a79ccc8d07b702010f491
fetchgit https://github.com/shaka-project/shaka-packager.git 56d33040452b64fd31a4d8c2497a122f5f97ac07
acheck

cd "${S}" || exit

apatch "$FILESDIR/shaka-packager-2.6.1.20221217-error_ignore.patch"

cd "${T}" || exit

importpkg net-dns/c-ares

docmake

finalize
