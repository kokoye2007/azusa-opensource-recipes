#!/bin/sh
source "../../common/init.sh"

get https://gstreamer.freedesktop.org/src/${PN}/${P}.tar.xz
acheck

importpkg zlib app-arch/bzip2

cd "${T}"

domeson -Dpackage-origin=http://www.linuxfromscratch.org/blfs/view/svn/ -Dpackage-name="GStreamer 1.16.2 BLFS"

finalize
