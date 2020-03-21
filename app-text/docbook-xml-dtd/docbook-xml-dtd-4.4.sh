#!/bin/sh
source "../../common/init.sh"
inherit xmlcatalog

get http://www.docbook.org/xml/${PV}/docbook-xml-${PV}.zip
acheck

mkdir -p "${D}/pkg/main/${PKG}.sgml.${PVRF}/docbook/xml-dtd-${PV}"
chown -R root.root .
cp -v -af docbook.cat *.dtd ent/ *.mod "${D}/pkg/main/${PKG}.sgml.${PVRF}/docbook/xml-dtd-${PV}"

# generate docbook file
X="${D}/pkg/main/${PKG}.sgml.${PVRF}/docbook-${PV}.xml"
docbookdir="/pkg/main/${PKG}.sgml.${PVRF}/docbook/xml-dtd-${PV}"

xmlcatalog --noout --create "$X"

adds=(
	"public"         "-//OASIS//DTD DocBook XML V4.5//EN"                                     "http://www.oasis-open.org/docbook/xml/4.5/docbookx.dtd"
	"public"         "-//OASIS//ELEMENTS DocBook XML Information Pool V${PV}//EN"             "${docbookdir}/dbpoolx.mod"
	"public"         "-//OASIS//DTD DocBook XML V${PV}//EN"                                   "${docbookdir}/docbookx.dtd"
	"public"         "-//OASIS//ENTITIES DocBook XML Character Entities V${PV}//EN"           "${docbookdir}/dbcentx.mod"
	"public"         "-//OASIS//ENTITIES DocBook XML Notations V${PV}//EN"                    "${docbookdir}/dbnotnx.mod"
	"public"         "-//OASIS//ENTITIES DocBook XML Additional General Entities V${PV}//EN"  "${docbookdir}/dbgenent.mod"
	"public"         "-//OASIS//ELEMENTS DocBook XML Document Hierarchy V${PV}//EN"           "${docbookdir}/dbhierx.mod"
	"public"         "-//OASIS//DTD XML Exchange Table Model 19990315//EN"                    "${docbookdir}/soextblx.dtd"
	"public"         "-//OASIS//DTD DocBook XML CALS Table Model V${PV}//EN"                  "${docbookdir}/calstblx.dtd"
	"rewriteSystem"  "http://www.oasis-open.org/docbook/xml/${PV}"                            "${docbookdir}"
	"rewriteURI"     "http://www.oasis-open.org/docbook/xml/${PV}"                            "${docbookdir}"
)

multi_xmlcatalog_add "$X" "${adds[@]}"

# generate xmlcatalog entries
cat >"${X}.xmlcatalog" <<EOF
delegateSystem http://www.oasis-open.org/docbook/xml/$PV/
delegateURI http://www.oasis-open.org/docbook/xml/$PV/
EOF

cat >"${D}/${docbookdir}/.xmlcatalog" <<EOF
rewriteSystem http://www.oasis-open.org/docbook/xml/$PV
rewriteURI http://www.oasis-open.org/docbook/xml/$PV
EOF

cat >"${D}/${docbookdir}/docbookx.dtd.xmlcatalog" <<EOF
public -//OASIS//DTD DocBook XML V$PV//EN
EOF

finalize
