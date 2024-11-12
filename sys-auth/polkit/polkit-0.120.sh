#!/bin/sh
source "../../common/init.sh"

get https://www.freedesktop.org/software/polkit/releases/"${P}".tar.gz
acheck

cd "${S}" || exit

apatch \
	"$FILESDIR/polkit-0.120-duktape-js.patch" \
	"$FILESDIR/polkit-0.120-cve-2021-4034.patch" \
	"$FILESDIR/polkit-0.120-CVE-2021-4115.patch"

aautoreconf

cd "${T}" || exit

importpkg expat sys-libs/pam

# TODO --enable-man-pages
doconf --disable-static --disable-man-pages --disable-gtk-doc --disable-examples --enable-nls --with-authfw=pam --with-os-type=azusa --enable-libsystemd-login=no --enable-libelogind=no --with-duktape

make
make install DESTDIR="${D}"

wipesuid
finalize
