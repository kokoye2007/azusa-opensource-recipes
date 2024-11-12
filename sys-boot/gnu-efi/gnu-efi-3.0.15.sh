#!/bin/sh
source "../../common/init.sh"

get https://download.sourceforge.net/"${PN}"/"${P}".tar.bz2
acheck

cd "${S}" || exit

sed -i -e "s/-Werror//" Make.defaults

case "$ARCH" in
	arm) gnuarch=arm ;;
	arm64) gnuarch=aarch64 ;;
	386) gnuarch=ia32 ;;
	ia64) gnuarch=ia64 ;;
	amd64) gnuarch=x86_64 ;;
	*) die "Unknown arch"
esac

MAKEOPTS=(
	ARCH="$gnuarch"
	PREFIX="/pkg/main/${PKG}.core.${PVRF}"
	LIBDIR="/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX"
	INSTALLROOT="${D}"
)

make "${MAKEOPTS[@]}"
make install "${MAKEOPTS[@]}"

finalize
