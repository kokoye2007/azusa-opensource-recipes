#!/bin/sh
source "../../common/init.sh"

get https://dl.bintray.com/boostorg/release/${PV}/source/boost_${PV//./_}.tar.bz2

cd "boost_${PV//./_}"

# configure & build
./bootstrap.sh --with-icu --with-python=python2.7 --with-python-root=/pkg/main/dev-lang.python.core.2.7/ --with-python-version=2.7 --prefix="/pkg/main/${PKG}.core.${PVR}"

./b2 --ignore-site-config stage threading=multi link=shared -j8
./b2 --ignore-site-config install link=shared --prefix="${D}/pkg/main/${PKG}.core.${PVR}"

finalize
