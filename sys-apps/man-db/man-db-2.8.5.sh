#!/bin/sh
source "../../common/init.sh"

get http://download.savannah.nongnu.org/releases/man-db/${P}.tar.xz

if [ ! -d ${P} ]; then
	tar xf ${P}.tar.xz
fi

echo "Compiling ${P} ..."
cd ${T}

# configure & build
${CHPATH}/${P}/configure >configure.log 2>&1 --prefix=/pkg/main/${PKG}.core.${PVR}

make >make.log 2>&1
make >make_install.log 2>&1 install DESTDIR="${D}"

