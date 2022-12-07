#!/bin/sh
source "../../common/init.sh"

get https://github.com/ndevilla/iniparser/archive/v${PV}.tar.gz ${P}.tar.gz
acheck

cd "${S}"

make
make check

mv -v libiniparser.so.1 libiniparser.so.1.0.0
ln -sv libiniparser.so.1.0.0 libiniparser.so.1
ln -sv libiniparser.so.1.0.0 libiniparser.so

mkdir -p "${D}/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX"
mv -v libiniparser* "${D}/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX"
mkdir -p "${D}/pkg/main/${PKG}.dev.${PVRF}/include"
cp src/*.h "${D}/pkg/main/${PKG}.dev.${PVRF}/include"

makepkgconfig -liniparser

finalize
