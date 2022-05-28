#!/bin/sh
source "../../common/init.sh"
inherit asciidoc

get https://download.gimp.org/pub/${PN}/${PV:0:3}/${P}.tar.xz
acheck

cd "${T}"

importpkg libjpeg

MESONOPTS=(
	-Ddocs=false
	-Dexiv2=disabled
	-Dgdk-pixbuf=enabled
	-Djasper=disabled
	#  - libspiro: not in portage main tree
	-Dlibspiro=disabled
	-Dlua=disabled
	-Dmrg=disabled
	-Dpango=enabled
	-Dsdl2=disabled
	#  - Parameter -Dworkshop=false disables any use of Lua, effectivly
	-Dworkshop=false
	-Dcairo=enabled
	-Dpangocairo=enabled
	-Dlibav=enabled
	-Dlcms=enabled
	-Dlensfun=enabled
	-Dopenexr=enabled
	-Dpoppler=enabled
	-Dlibraw=enabled
	-Dsdl1=enabled
	-Dlibrsvg=enabled
	-Dpygobject=disabled
	-Dlibtiff=enabled
	-Dumfpack=enabled
	-Dlibv4l=enabled
	-Dlibv4l2=enabled
	-Dvapigen=disabled
	-Dwebp=enabled
	-Dintrospection=true
)

domeson "${MESONOPTS[@]}"

#mkdir -p "${D}/pkg/main/${PKG}.doc.${PVRF}/html/images"

#install -v -m644 docs/*.{css,html} "${D}/pkg/main/${PKG}.doc.${PVRF}/html"
#install -v -m644 docs/images/*.{png,ico,svg} "${D}/pkg/main/${PKG}.doc.${PVRF}/html/images"

finalize
