#!/bin/sh
source "../../common/init.sh"

get http://sourceforge.net/projects/dejavu/files/dejavu/${PV}/dejavu-fonts-ttf-${PV}.tar.bz2
#get http://sourceforge.net/projects/dejavu/files/dejavu/${PV}/dejavu-fonts-${PV}.tar.bz2
acheck

cd "${S}"

mkdir -p "${D}/pkg/main/${PKG}.fonts.${PVRF}"
cp -r ttf fontconfig "${D}/pkg/main/${PKG}.fonts.${PVRF}/"

finalize
