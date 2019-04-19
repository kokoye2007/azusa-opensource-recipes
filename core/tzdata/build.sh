#!/bin/sh
set -e

TZDATA_VER=2019a
BASEDIR=`pwd`
source "$BASEDIR/../../common/init.sh"

# fetch, compile, build
if [ ! -f tzcode${TZDATA_VER}.tar.gz ]; then
	wget https://data.iana.org/time-zones/releases/tzcode${TZDATA_VER}.tar.gz
fi
if [ ! -f tzdata${TZDATA_VER}.tar.gz ]; then
	wget https://data.iana.org/time-zones/releases/tzdata${TZDATA_VER}.tar.gz
fi

if [ ! -d tzdata-${TZDATA_VER} ]; then
	echo "Extracting tzdata${TZDATA_VER}.tar.gz ..."
	mkdir tzdata-${TZDATA_VER}
	tar -C tzdata-${TZDATA_VER} -xf tzdata${TZDATA_VER}.tar.gz
	tar -C tzdata-${TZDATA_VER} -xf tzcode${TZDATA_VER}.tar.gz
fi

echo "Compiling tzdata-${TZDATA_VER} ..."

mkdir -p dist/pkg/main/core.tzdata.${TZDATA_VER}/{posix,right}
for tz in etcetera southamerica northamerica europe africa antarctica asia australasia backward pacificnew systemv; do
	zic -L /dev/null -d dist/pkg/main/core.tzdata.${TZDATA_VER}/ "tzdata-${TZDATA_VER}/$tz"
	zic -L /dev/null -d dist/pkg/main/core.tzdata.${TZDATA_VER}/posix "tzdata-${TZDATA_VER}/$tz"
	zic -L "tzdata-${TZDATA_VER}/leapseconds" -d dist/pkg/main/core.tzdata.${TZDATA_VER}/right "tzdata-${TZDATA_VER}/$tz"
done

echo "Building squashfs..."

# build squashfs files

mksquashfs "dist/pkg/main/core.tzdata.${TZDATA_VER}" "dist/core.tzdata.${TZDATA_VER}.${OS}.${ARCH}.squashfs" -all-root -nopad -noappend

if [ x"$HSM" != x ]; then
	tpkg-convert dist/*.squashfs
fi
