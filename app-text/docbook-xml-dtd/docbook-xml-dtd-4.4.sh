#!/bin/sh
source "../../common/init.sh"

get http://www.docbook.org/xml/${PV}/docbook-xml-${PV}.zip
acheck

mkdir -p "${D}/pkg/main/${PKG}.sgml.${PVR}/docbook/xml-dtd-${PV}"
chown -R root.root .
cp -v -af docbook.cat *.dtd ent/ *.mod "${D}/pkg/main/${PKG}.sgml.${PVR}/docbook/xml-dtd-${PV}"

finalize
