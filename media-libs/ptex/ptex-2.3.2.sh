#!/bin/sh
source "../../common/init.sh"

get https://github.com/wdas/ptex/archive/v${PV}.tar.gz
acheck

cd "${S}"

echo "$PV" >version

cd "${T}"

docmake -DPTEX_BUILD_STATIC_LIBS=ON

# fix cmake config file
find "${D}" -name '*-config.cmake' | xargs sed -i -e "s#^get_filename_component.*#get_filename_component(PACKAGE_PREFIX_DIR \"/pkg/main/${PKG}.dev.${PVRF}\" ABSOLUTE)#"

finalize
