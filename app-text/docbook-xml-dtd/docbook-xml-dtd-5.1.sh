#!/bin/sh
source "../../common/init.sh"

get https://docbook.org/xml/${PV}/docbook-v${PV}-os.zip
acheck

mkdir -p "${D}/pkg/main/${PKG}.sgml.${PVR}/docbook"/schema/{rng,sch}/5.1

install -vm644  schemas/rng/* "${D}/pkg/main/${PKG}.sgml.${PVR}/docbook/schema/rng/5.1"
install -vm644  schemas/sch/* "${D}/pkg/main/${PKG}.sgml.${PVR}/docbook/schema/sch/5.1"

mkdir "${D}/pkg/main/${PKG}.sgml.${PVR}/bin"
install -m755   tools/db4-entities.pl "${D}/pkg/main/${PKG}.sgml.${PVR}/bin"
mkdir -p "${D}/pkg/main/${PKG}.sgml.${PVR}/docbook/stylesheet/docbook5"
install -m644   tools/db4-upgrade.xsl "${D}/pkg/main/${PKG}.sgml.${PVR}/docbook/stylesheet/docbook5"

finalize
