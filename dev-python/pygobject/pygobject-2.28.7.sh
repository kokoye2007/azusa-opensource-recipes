#!/bin/sh
source ../../common/init.sh
source ${ROOTDIR}/common/python.sh

get https://download.gnome.org/sources/pygobject/${PV%.*}/${P}.tar.xz

cd "${P}"

pythonconfsetup --disable-introspection
archive
