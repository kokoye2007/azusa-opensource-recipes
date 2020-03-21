#!/bin/sh
source "../../common/init.sh"

get https://archive.apache.org/dist/serf/${P}.tar.bz2
acheck

cd "${P}"

sed -i "/Append/s:RPATH=libdir,::"          SConstruct
sed -i "/Default/s:lib_static,::"           SConstruct
sed -i "/Alias/s:install_static,::"         SConstruct
sed -i "/  print/{s/print/print(/; s/$/)/}" SConstruct
sed -i "/get_contents()/s/,/.decode()&/"    SConstruct

importpkg zlib openssl expat uuid

scons PREFIX="/pkg/main/${PKG}.core.${PVRF}" CPPFLAGS="$CPPFLAGS" LINKFLAGS="$LDFLAGS"
scons PREFIX="${D}/pkg/main/${PKG}.core.${PVRF}" install

finalize
