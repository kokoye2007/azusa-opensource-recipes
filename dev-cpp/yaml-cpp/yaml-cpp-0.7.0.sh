#!/bin/sh
source "../../common/init.sh"

get https://github.com/jbeder/yaml-cpp/archive/${P}.tar.gz
acheck

cd "${S}"

apatch "$FILESDIR/${P}-gtest.patch"

# fix yaml-cpp.pc.in
cat <<EOF >yaml-cpp.pc.in
prefix=@CMAKE_INSTALL_PREFIX@
exec_prefix=${prefix}
includedir=/pkg/main/${PKG}.dev.${PVRF}/include
libdir=/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX

Name: Yaml-cpp
Description: A YAML parser and emitter for C++
Version: @YAML_CPP_VERSION@
Requires:
Libs: -L${libdir} -lyaml-cpp
Cflags: -I${includedir}
EOF

cd "${T}"

# tools: util/parse util/read util/sandbox

docmake -DYAML_BUILD_SHARED_LIBS=ON -DYAML_CPP_BUILD_TOOLS=OFF

finalize
