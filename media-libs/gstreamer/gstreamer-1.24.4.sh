#!/bin/sh
source "../../common/init.sh"

get https://gstreamer.freedesktop.org/src/"${PN}"/"${P}".tar.xz
acheck

cd "${T}" || exit

importpkg gmp sys-libs/libunwind zlib

domeson -Dgst_debug=false -Dpackage-origin=http://www.linuxfromscratch.org/blfs/view/svn/ -Dpackage-name="GStreamer 1.16.2 BLFS"

finalize
