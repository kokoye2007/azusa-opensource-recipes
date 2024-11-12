#!/bin/sh
source "../../common/init.sh"

get https://github.com/FreeRDP/FreeRDP/archive/"${PV}".tar.gz
acheck

cd "${T}" || exit

importpkg X zlib dev-libs/libusb x11-libs/cairo net-print/cups sys-apps/pcsc-lite media-libs/libjpeg-turbo media-libs/x264 media-libs/openh264 media-libs/soxr

CMAKE_ROOT="${CHPATH}/FreeRDP-${PV}" docmake -DWITH_LIBSYSTEMD=OFF -DWITH_JPEG=ON -DWITH_X264=ON -DWITH_OPENH264=ON -DWITH_LAME=ON -DWITH_FAAD2=ON -DWITH_SOXR=ON -DWITH_IPP=ON

make
make install DESTDIR="${D}"

finalize
