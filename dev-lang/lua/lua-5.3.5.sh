#!/bin/sh
source "../../common/init.sh"

get http://www.lua.org/ftp/${P}.tar.gz
acheck

cd "${P}"

importpkg sys-libs/readline sys-libs/ncurses

# TODO need to update luaconf.h for LUA_ROOT etc

make linux PLAT=linux MYLDFLAGS="${LDFLAGS}" MYLIBS="-lncurses" INSTALL_TOP="/pkg/main/${PKG}.core.${PVRF}" INSTALL_INC="/pkg/main/${PKG}.dev.${PVRF}/include" INSTALL_LIB="/pkg/main/${PKG}.libs.${PVRF}/lib" INSTALL_MAN="/pkg/main/${PKG}.doc.${PVRF}/man/man1"

# not exactly the same values for install
make install INSTALL_TOP="${D}/pkg/main/${PKG}.core.${PVRF}" INSTALL_INC="${D}/pkg/main/${PKG}.dev.${PVRF}/include" INSTALL_LIB="${D}/pkg/main/${PKG}.libs.${PVRF}/lib" INSTALL_MAN="${D}/pkg/main/${PKG}.doc.${PVRF}/man/man1"

finalize
