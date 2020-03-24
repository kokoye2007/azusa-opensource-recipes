#!/bin/sh
source "../../common/init.sh"

get https://linuxtv.org/downloads/${PN}/${P}.tar.gz
acheck

cd "${S}"

PATCHES=(
	"${FILESDIR}/${PN}-0.10-errors.patch"
	"${FILESDIR}/${P}_create_correct_pkconfig_file_for_zbar-qt5.patch"
	"${FILESDIR}/${P}_fix_detection_of_errors_in_the_v4l_read.patch"
	"${FILESDIR}/${P}_fix_python_detect.patch"
	"${FILESDIR}/${P}_fix_Qt5X11Extras_detect.patch"
	"${FILESDIR}/${P}_reset_conversion_descriptor_after_close.patch"
)

apatch "${PATCHES[@]}"
aautoreconf

cd "${T}"

importpkg X libjpeg media-libs/mesa

doconf --with-dbus --with-gtk3 --with-jpeg --with-gir --with-python=auto --disable-static --enable-pthread --enable-video --with-x --with-xshm --with-xv --with-graphicsmagick --without-imagemagick --with-qt --with-qt5 

make
make install DESTDIR="${D}"

finalize
