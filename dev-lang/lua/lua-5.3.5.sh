#!/bin/sh
source "../../common/init.sh"

get http://www.lua.org/ftp/${P}.tar.gz

cd "${P}"

# TODO need to update luaconf.h for LUA_ROOT etc

make linux INSTALL_TOP="/pkg/main/${PKG}.core.${PVR}" INSTALL_INC="/pkg/main/${PKG}.dev.${PVR}/include" INSTALL_LIB="/pkg/main/${PKG}.libs.${PVR}/lib" INSTALL_MAN="/pkg/main/${PKG}.doc.${PVR}/man/man1"

# not exactly the same values for install
make install INSTALL_TOP="${D}/pkg/main/${PKG}.core.${PVR}" INSTALL_INC="${D}/pkg/main/${PKG}.dev.${PVR}/include" INSTALL_LIB="${D}/pkg/main/${PKG}.libs.${PVR}/lib" INSTALL_MAN="${D}/pkg/main/${PKG}.doc.${PVR}/man/man1"

finalize
