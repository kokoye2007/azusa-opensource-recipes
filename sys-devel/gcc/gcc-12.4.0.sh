#!/bin/sh
source "../../common/init.sh"

get http://ftp.tsukuba.wide.ad.jp/software/gcc/releases/"${P}"/"${P}".tar.xz
acheck

cd "${T}" || exit

export SED=sed

# make sure gcc can find stuff like -lz
importpkg zlib libcrypt libzstd dev-util/systemtap sys-libs/libxcrypt

if [ -f /pkg/main/sys-devel.gcc.core/bin/cpp ]; then
	export CPP=/pkg/main/sys-devel.gcc.core/bin/cpp
fi

# note: we disable systemtap because gcc cannot look into the path we give it through CPPFLAGS
# checking sys/sdt.h in the target C library... no
# configure: error: sys/sdt.h was not found

# languages:
# all, default, ada, c, c++, d, fortran, go, jit, lto, objc, obj-c++

# configure & build
callconf --prefix=/pkg/main/"${PKG}".core."${PVRF}" --infodir=/pkg/main/"${PKG}".doc."${PVRF}"/info --mandir=/pkg/main/"${PKG}".doc."${PVRF}"/man --docdir=/pkg/main/"${PKG}".doc."${PVRF}"/gcc \
--with-pkgversion="Azusa gcc $PVRF" --with-bugurl=https://github.com/AzusaOS/azusa-opensource-recipes/issues \
--libdir=/pkg/main/"${PKG}".libs."${PVRF}"/lib"$LIB_SUFFIX" --with-slibdir=/pkg/main/"${PKG}".libs."${PVRF}"/lib"$LIB_SUFFIX" \
--with-gxx-include-dir=/pkg/main/"${PKG}".dev."${PVRF}"/include/c++ --with-sysroot=/pkg/main/sys-libs.glibc.dev."${OS}"."${ARCH}" \
--with-gcc-major-version-only \
--enable-languages=all --disable-multilib --disable-bootstrap --disable-libmpx --with-system-zlib \
--enable-obsolete --enable-secureplt --disable-werror --enable-nls --without-included-gettext --disable-libunwind-exceptions \
--enable-esp --enable-libstdcxx-time --with-build-config=bootstrap-lto --disable-libstdcxx-pch --enable-__cxa_atexit --enable-clocale=gnu \
--enable-cet --disable-systemtap --with-zstd --enable-lto --enable-default-ssp --enable-default-pie \
--with-mpfr-include=$(realpath /pkg/main/dev-libs.mpfr.dev."${OS}"."${ARCH}"/include) --with-mpfr-lib=$(realpath /pkg/main/dev-libs.mpfr.libs."${OS}"."${ARCH}"/lib"$LIB_SUFFIX") \
--with-mpc-include=$(realpath /pkg/main/dev-libs.mpc.dev."${OS}"."${ARCH}"/include) --with-mpc-lib=$(realpath /pkg/main/dev-libs.mpc.libs."${OS}"."${ARCH}"/lib"$LIB_SUFFIX") \
--with-gmp-include=$(realpath /pkg/main/dev-libs.gmp.dev."${OS}"."${ARCH}"/include) --with-gmp-lib=$(realpath /pkg/main/dev-libs.gmp.libs."${OS}"."${ARCH}"/lib"$LIB_SUFFIX") \
--with-isl-include=$(realpath /pkg/main/dev-libs.isl.dev."${OS}"."${ARCH}"/include) --with-isl-lib=$(realpath /pkg/main/dev-libs.isl.libs."${OS}"."${ARCH}"/lib"$LIB_SUFFIX") \
CPPFLAGS="$CPPFLAGS" LDFLAGS="$LDFLAGS"

make -j"$NPROC"
make install DESTDIR="${D}"

ln -sv gcc "${D}/pkg/main/${PKG}.core.${PVRF}/bin/cc"

# remove any .la file
find "${D}" -name '*.la' -delete

# create gentoo-like config file in an effort to please clang
# see /etc/env.d/gcc/ on a gentoo system
# you can symlink /pkg/main/sys-devel.gcc.dev/gcc-config as {{sysroot}}/etc/env.d/gcc and clang might be happy
TRIPLE="$("${D}/pkg/main/${PKG}.core.${PVRF}/bin/gcc" -dumpmachine)"
VERS="$("${D}/pkg/main/${PKG}.core.${PVRF}/bin/gcc" -dumpversion)"

mkdir -p "${D}/pkg/main/${PKG}.dev.${PVRF}/gcc-config"
echo "CURRENT=${TRIPLE}-${PV}" >"${D}/pkg/main/${PKG}.dev.${PVRF}/gcc-config/config-${TRIPLE}"

cat >"${D}/pkg/main/${PKG}.dev.${PVRF}/gcc-config/${TRIPLE}-${PV}" <<EOF
GCC_PATH="/pkg/main/${PKG}.core.${PVRF}/bin"
LDPATH="/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX/gcc/${TRIPLE}/${VERS}"
MANPATH="/pkg/main/${PKG}.doc.${PVRF}/man"
INFOPATH="/pkg/main/${PKG}.doc.${PVRF}/info"
STDCXX_INCDIR="/pkg/main/${PKG}.dev.${PVRF}/include/c++"
CTARGET="${TRIPLE}"
GCC_SPECS=""
EOF
if [ "$MULTILIB" = "yes" ]; then
	echo "MULTIOSDIRS=\"../lib64:../lib\"" >>"${D}/pkg/main/${PKG}.dev.${PVRF}/gcc-config/${TRIPLE}-${PV}"
fi

# do not use finalize because we depend on location of some files
fixelf
archive
