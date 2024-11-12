#!/bin/sh
source "../../common/init.sh"

# fetch, compile, build
get https://data.iana.org/time-zones/releases/tzcode"${PV}".tar.gz
get https://data.iana.org/time-zones/releases/tzdata"${PV}".tar.gz

if [ ! -d tzdata-"${PV}" ]; then
	echo "Extracting tzdata${PV}.tar.gz ..."
	mkdir tzdata-"${PV}"
	tar -C tzdata-"${PV}" -xf tzdata"${PV}".tar.gz
	tar -C tzdata-"${PV}" -xf tzcode"${PV}".tar.gz
fi

echo "Compiling tzdata-${PV} ..."

mkdir -p "${D}"/pkg/main/"${PKG}".core."${PV}"/{posix,right}
for tz in etcetera southamerica northamerica europe africa antarctica asia australasia backward; do
	zic -L /dev/null -d "${D}"/pkg/main/"${PKG}".core."${PV}"/ "tzdata-${PV}/$tz"
	zic -L /dev/null -d "${D}"/pkg/main/"${PKG}".core."${PV}"/posix "tzdata-${PV}/$tz"
	zic -L "tzdata-${PV}/leapseconds" -d "${D}"/pkg/main/"${PKG}".core."${PV}"/right "tzdata-${PV}/$tz"
done

finalize
cleanup
