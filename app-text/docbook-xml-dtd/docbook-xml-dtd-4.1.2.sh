#!/bin/sh
source "../../common/init.sh"

MY_P="docbkx${PV//./}"
get https://docbook.org/xml/${PV}/${MY_P}.zip
acheck

mkdir -p "${D}/pkg/main/${PKG}.sgml.${PVR}/docbook/xml-dtd-${PV}"
chown -R root.root .
cp -v -af docbook.cat *.dtd ent/ *.mod "${D}/pkg/main/${PKG}.sgml.${PVR}/docbook/xml-dtd-${PV}"

finalize
