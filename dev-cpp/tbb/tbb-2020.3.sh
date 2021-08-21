#!/bin/sh
source "../../common/init.sh"

MY_PV="${PV/.*}_U${PV/*.}"
get https://github.com/intel/${PN}/archive/${MY_PV}.tar.gz
acheck

cd "${S}"

cat <<-EOF > ${PN}.pc.template
prefix=/pkg/main/${PKG}.core.${PVRF}
libdir=/pkg/main/${PKG}.libs.${PVRF}/lib${LIB_SUFFIX}
includedir=/pkg/main/${PKG}.dev.${PVRF}/include
Name: ${PN}
Description: High level abstract threading library
Version: ${PV}
URL: https://www.threadingbuildingblocks.org
Cflags: -I\${includedir}
EOF

cp ${PN}.pc.template ${PN}.pc

cat <<-EOF >> ${PN}.pc
Libs: -L\${libdir} -ltbb
Libs.private: -lm -lrt
EOF

cp ${PN}.pc.template ${PN}malloc.pc
cat <<-EOF >> ${PN}malloc.pc
Libs: -L\${libdir} -ltbbmalloc
Libs.private: -lm -lrt
EOF

cp ${PN}.pc.template ${PN}malloc_proxy.pc
cat <<-EOF >> ${PN}malloc_proxy.pc
Libs: -L\${libdir} -ltbbmalloc_proxy
Libs.private: -lrt
Requires: tbbmalloc
EOF

case $ARCH in
	amd64) arch=x86_64 ;;
	386) arch=ia32 ;;
	# ...
	*)
		die "arch not supported"
		;;
esac

make arch="$arch" CPLUS_FLAGS="${CXXFLAGS}" compiler=gcc work_dir="${T}" tbb_root="${S}" cfg=release tbb tbbmalloc

# install

mkdir -p "${D}/pkg/main/${PKG}.dev.${PVRF}/pkgconfig"
cp -v *.pc "${D}/pkg/main/${PKG}.dev.${PVRF}/pkgconfig"

mv -Tv include "${D}/pkg/main/${PKG}.dev.${PVRF}/include"

cd "${T}_release"

mkdir -p "${D}/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX"
cp -v lib* "${D}/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX"

finalize
