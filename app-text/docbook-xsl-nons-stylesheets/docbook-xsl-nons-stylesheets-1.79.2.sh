#!/bin/sh
source "../../common/init.sh"

get https://github.com/docbook/xslt10-stylesheets/releases/download/release/${PV}/docbook-xsl-nons-${PV}.tar.bz2
acheck

cd docbook-xsl-nons-${PV}

apatch "$FILESDIR/docbook-xsl-nons-1.79.2-stack_fix-1.patch"

mkdir -p "${D}/pkg/main/${PKG}.sgml.${PVR}/docbook/xsl-stylesheets-nons-${PV}"

cp -v -R VERSION assembly common eclipse epub epub3 extensions fo        \
	highlighting html htmlhelp images javahelp lib manpages params  \
	profiling roundtrip slides template tests tools webhelp website \
	xhtml xhtml-1_1 xhtml5                                          \
	"${D}/pkg/main/${PKG}.sgml.${PVR}/docbook/xsl-stylesheets-nons-${PV}"

ln -s VERSION "${D}/pkg/main/${PKG}.sgml.${PVR}/docbook/xsl-stylesheets-nons-${PV}/VERSION.xsl"

# generate sgml authority record
cat >"${D}/pkg/main/${PKG}.sgml.${PVR}/docbook/xsl-stylesheets-nons-${PV}/.xmlcatalog" <<EOF
rewriteSystem https://cdn.docbook.org/release/xsl-nons/${PV}
rewriteURI https://cdn.docbook.org/release/xsl-nons/${PV}
rewriteSystem https://cdn.docbook.org/release/xsl-nons/current
rewriteURI https://cdn.docbook.org/release/xsl-nons/current
rewriteSystem http://docbook.sourceforge.net/release/xsl/current
rewriteURI http://docbook.sourceforge.net/release/xsl/current
EOF

finalize
