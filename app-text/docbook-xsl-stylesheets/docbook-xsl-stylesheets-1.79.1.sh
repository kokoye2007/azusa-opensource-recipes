#!/bin/sh
source "../../common/init.sh"

MY_PN="${PN%-stylesheets}"
MY_P="${MY_PN}-${PV}"

get https://downloads.sourceforge.net/docbook/${MY_P}.tar.bz2
acheck

cd "${MY_P}"

patch -Np1 -i "$FILESDIR/nonrecursive-string-subst.patch"

mkdir -p "${D}/pkg/main/${PKG}.sgml.${PVR}/docbook/xsl-stylesheets"

cp -v -R VERSION assembly common eclipse epub epub3 extensions fo        \
	highlighting html htmlhelp images javahelp lib manpages params  \
	profiling roundtrip slides template tests tools webhelp website \
	xhtml xhtml-1_1 xhtml5                                          \
	"${D}/pkg/main/${PKG}.sgml.${PVR}/docbook/xsl-stylesheets"

ln -s VERSION "${D}/pkg/main/${PKG}.sgml.${PVR}/docbook/xsl-stylesheets/VERSION.xsl"


finalize
