#!/bin/sh
source "../../common/init.sh"

get https://github.com/TigerVNC/${PN}/archive/v${PV}.tar.gz ${P}.tar.gz
acheck

cd "${T}"

importpkg X x11-libs/fltk media-libs/fontconfig zlib libjpeg sys-libs/pam pixman-1

docmake -DGETTEXT_INCLUDE_DIR=/pkg/main/sys-libs.glibc.dev/include -DFLTK_MATH_LIBRARY=

finalize
