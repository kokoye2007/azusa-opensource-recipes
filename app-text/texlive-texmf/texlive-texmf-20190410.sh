#!/bin/sh
source "../../common/init.sh"

mkdir -p "${D}/pkg/main/${PKG}.core.${PVR}"
cd "${D}/pkg/main/${PKG}.core.${PVR}"
get ftp://tug.org/texlive/historic/${PV:0:4}/texlive-${PV}-texmf.tar.xz

mv texlive-${PV}-texmf/texmf-dist .
rmdir "texlive-${PV}-texmf"
rm -f texlive-${PV}-texmf.tar.xz

# need to move texmf-dist/doc and texmf-dist/fonts (over 2GB each)
for foo in "${D}/pkg/main/${PKG}.core.${PVR}/texmf-dist/doc"/*; do
	BASE=`basename "$foo"`
	mv -v "$foo" "${D}/pkg/main/${PKG}.data.doc.$BASE.${PVR}"
	ln -snf "/pkg/main/${PKG}.data.doc.$BASE.${PVR}" "$foo"
done

for foo in "${D}/pkg/main/${PKG}.core.${PVR}/texmf-dist/fonts"/*; do
	BASE=`basename "$foo"`
	mv -v "$foo" "${D}/pkg/main/${PKG}.data.fonts.$BASE.${PVR}"
	ln -snf "/pkg/main/${PKG}.data.fonts.$BASE.${PVR}" "$foo"
done

finalize
