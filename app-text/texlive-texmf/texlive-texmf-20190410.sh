#!/bin/sh
source "../../common/init.sh"

mkdir -p "${D}/pkg/main/${PKG}.core.${PVRF}"
cd "${D}/pkg/main/${PKG}.core.${PVRF}" || exit
get ftp://tug.org/texlive/historic/"${PV:0:4}"/texlive-"${PV}"-texmf.tar.xz

mv texlive-"${PV}"-texmf/texmf-dist .
rmdir "texlive-${PV}-texmf"
rm -f texlive-"${PV}"-texmf.tar.xz

# need to move texmf-dist/doc and texmf-dist/fonts (over 2GB each)
for foo in "${D}/pkg/main/${PKG}.core.${PVRF}/texmf-dist/doc"/*; do
	BASE=$(basename "$foo")
	mv -v "$foo" "${D}/pkg/main/${PKG}.data.doc.$BASE.${PVRF}"
	ln -snf "/pkg/main/${PKG}.data.doc.$BASE.${PVRF}" "$foo"
done

for foo in "${D}/pkg/main/${PKG}.core.${PVRF}/texmf-dist/fonts"/*; do
	BASE=$(basename "$foo")
	mv -v "$foo" "${D}/pkg/main/${PKG}.data.fonts.$BASE.${PVRF}"
	ln -snf "/pkg/main/${PKG}.data.fonts.$BASE.${PVRF}" "$foo"
done

finalize
