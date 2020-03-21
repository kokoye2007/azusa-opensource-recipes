#!/bin/sh
source "../../common/init.sh"

get https://docbook.org/xml/${PV}/docbook-v${PV}-os.zip
acheck

mkdir -p "${D}/pkg/main/${PKG}.sgml.${PVRF}/docbook"/schema/{rng,sch}/5.1

install -vm644  schemas/rng/* "${D}/pkg/main/${PKG}.sgml.${PVRF}/docbook/schema/rng/5.1"
install -vm644  schemas/sch/* "${D}/pkg/main/${PKG}.sgml.${PVRF}/docbook/schema/sch/5.1"

mkdir "${D}/pkg/main/${PKG}.sgml.${PVRF}/bin"
install -m755   tools/db4-entities.pl "${D}/pkg/main/${PKG}.sgml.${PVRF}/bin"
mkdir -p "${D}/pkg/main/${PKG}.sgml.${PVRF}/docbook/stylesheet/docbook5"
install -m644   tools/db4-upgrade.xsl "${D}/pkg/main/${PKG}.sgml.${PVRF}/docbook/stylesheet/docbook5"

finalize
