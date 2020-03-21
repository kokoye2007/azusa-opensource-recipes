#!/bin/sh
source "../../common/init.sh"

get https://github.com/g-truc/glm/archive/${PV}.tar.gz ${P}.tar.gz
acheck

cd "${S}"

docmake

make -j"$NPROC"
make test

# doesn't have install script
install -vd "${D}/pkg/main/${PKG}.dev.${PVRF}/include"
cp -rvT glm "${D}/pkg/main/${PKG}.dev.${PVRF}/include/glm"

install -v -d "${D}/pkg/main/${PKG}.dev.${PVRF}/pkgconfig/"

install -vd "${D}/pkg/main/${PKG}.doc.${PVRF}"
install -v readme.md manual.md "${D}/pkg/main/${PKG}.doc.${PVRF}"

cat >>"${D}/pkg/main/${PKG}.dev.${PVRF}/pkgconfig/glm.pc" <<EOF
prefix=/pkg/main/${PKG}.dev.${PVRF}
includedir=\${prefix}/include

Name: GLM
Description: OpenGL Mathematics
Version: ${PV%.*}
Cflags: -I\${includedir}
EOF

# TODO also install cmake files?

finalize
