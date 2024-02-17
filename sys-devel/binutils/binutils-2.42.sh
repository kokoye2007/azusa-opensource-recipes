#!/bin/sh
source "../../common/init.sh"

get https://ftp.gnu.org/gnu/binutils/${P}.tar.xz
acheck

importpkg zlib dev-libs/elfutils dev-libs/isl dev-libs/mpfr dev-libs/gmp

# default libpath should include glibc path so gcc can find -lc
export LIB_PATH=/lib:/pkg/main/sys-devel.gcc.libs/lib$LIB_SUFFIX:/pkg/main/sys-libs.glibc.libs/lib$LIB_SUFFIX
#export C_INCLUDE_PATH=

cd "${T}"

CONFOPTS=(
	--enable-gold
	--enable-ld=default
	--enable-plugins
	--enable-shared
	--enable-64-bit-bfd
	--with-system-zlib
	--with-sysroot=/pkg/main/sys-libs.glibc.dev
	--with-gcc-major-version-only
	--enable-deterministic-archives
)

# configure & build
doconf "${CONFOPTS[@]}"

make
make install DESTDIR="${D}"

finalize
