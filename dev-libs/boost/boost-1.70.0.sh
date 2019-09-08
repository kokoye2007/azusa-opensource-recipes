#!/bin/sh
source "../../common/init.sh"

get https://dl.bintray.com/boostorg/release/${PV}/source/boost_1_70_0.tar.bz2

cd "boost_1_70_0"

# configure & build
./bootstrap.sh --with-icu --prefix=/pkg/main/${PKG}.core.${PVR}

./b2 --ignore-site-config
./b2 --ignore-site-config install --prefox="${D}/pkg/main/${PKG}.core.${PVR}"

finalize
