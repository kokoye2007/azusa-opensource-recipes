#!/bin/sh
source "../../common/init.sh"

get https://github.com/docbook/xslt10-stylesheets/releases/download/release/${PV}/docbook-xsl-${PV}.tar.bz2
acheck

cd docbook-xsl-${PV}

mkdir -p "${D}/pkg/main/${PKG}.sgml.${PVR}/docbook/xsl-stylesheets-${PV}"

cp -v -R VERSION assembly common eclipse epub epub3 extensions fo        \
	highlighting html htmlhelp images javahelp lib manpages params  \
	profiling roundtrip slides template tests tools webhelp website \
	xhtml xhtml-1_1 xhtml5                                          \
	"${D}/pkg/main/${PKG}.sgml.${PVR}/docbook/xsl-stylesheets-${PV}"

ln -s VERSION "${D}/pkg/main/${PKG}.sgml.${PVR}/docbook/xsl-stylesheets-${PV}/VERSION.xsl"

# generate sgml authority record
cat >"${D}/pkg/main/${PKG}.sgml.${PVR}/docbook/xsl-stylesheets-${PV}/.xmlcatalog" <<EOF
rewriteSystem https://cdn.docbook.org/release/xsl/${PV}
rewriteURI https://cdn.docbook.org/release/xsl/${PV}
rewriteSystem https://cdn.docbook.org/release/xsl/current
rewriteURI https://cdn.docbook.org/release/xsl/current
rewriteSystem http://docbook.sourceforge.net/release/xsl-ns/current
rewriteURI http://docbook.sourceforge.net/release/xsl-ns/current
EOF

finalize
