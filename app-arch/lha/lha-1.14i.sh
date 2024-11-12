#!/bin/sh
source "../../common/init.sh"

get https://osdn.net/projects/lha/downloads/22231/lha-1.14i-ac20050924p1.tar.gz
acheck

prepare

cd "${T}" || exit

callconf --prefix=/pkg/main/"${PKG}".core."${PVRF}" --sysconfdir=/etc \
	--includedir=/pkg/main/"${PKG}".dev."${PVRF}"/include --libdir=/pkg/main/"${PKG}".libs."${PVRF}"/lib \
	--mandir=/pkg/main/"${PKG}".doc."${PVRF}"/man

make
make install DESTDIR="${D}"

finalize

