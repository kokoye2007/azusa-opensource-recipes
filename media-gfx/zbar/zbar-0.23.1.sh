#!/bin/sh
source "../../common/init.sh"

get https://linuxtv.org/downloads/${PN}/${P}.tar.gz
acheck

cd "${S}"

PATCHES=(
	"${FILESDIR}/${P}_fix_leftover_on_shell_compatibility.patch"
	"${FILESDIR}/${P}_fix_unittest.patch"
	"${FILESDIR}/${P}_musl_include_locale_h.patch"
	"${FILESDIR}/${PN}-0.23_fix_Qt5X11Extras_detect.patch"
	"${FILESDIR}/${PN}-0.23_fix_python_detect.patch"
	"${FILESDIR}/${P}-autoconf-2.70.patch"
	"${FILESDIR}/${PN}-0.23.1_python_tp_print.patch"
)

apatch "${PATCHES[@]}"
aautoreconf

cd "${T}"

importpkg X libjpeg media-libs/mesa

doconf --with-dbus --with-gtk3 --with-jpeg --with-gir --with-python=auto --disable-static --enable-pthread --enable-video --with-x --with-xshm --with-xv --with-graphicsmagick --without-imagemagick --with-qt --with-qt5 

make
make install DESTDIR="${D}"

finalize
