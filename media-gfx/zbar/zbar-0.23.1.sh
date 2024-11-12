#!/bin/sh
source "../../common/init.sh"

get https://linuxtv.org/downloads/"${PN}"/"${P}".tar.gz
acheck

cd "${S}" || exit

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
touch zbar/gettext.h
aautoreconf

cd "${T}" || exit

importpkg X libjpeg media-libs/mesa zlib

doconf --with-dbus --with-gtk3 --with-jpeg --with-gir --with-python=auto --disable-static --enable-pthread --enable-video --with-x --with-xshm --with-xv --with-graphicsmagick --without-imagemagick --without-qt --without-qt5 

make
make install DESTDIR="${D}"

finalize
