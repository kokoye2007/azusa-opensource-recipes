#!/bin/sh
source "../../common/init.sh"

get https://github.com/wdas/ptex/archive/v"${PV}".tar.gz
acheck

cd "${S}" || exit

echo "$PV" >version

# force absolute path for CMAKE_DIR
# /pkg/main/media-libs.ptex.dev.2.3.2.linux.amd64/cmake/Ptex
sed -i "s#^set(CMAKE_DIR.*#set(CMAKE_DIR \"/pkg/main/${PKG}.dev.${PVRF}/cmake/Ptex\")#" src/build/CMakeLists.txt

cd "${T}" || exit

docmake -DPTEX_BUILD_STATIC_LIBS=ON

# fix cmake config file
find "${D}" -name '*-config.cmake' | xargs sed -i -e "s#^get_filename_component.*#get_filename_component(PACKAGE_PREFIX_DIR \"/pkg/main/${PKG}.dev.${PVRF}\" ABSOLUTE)#"

finalize
