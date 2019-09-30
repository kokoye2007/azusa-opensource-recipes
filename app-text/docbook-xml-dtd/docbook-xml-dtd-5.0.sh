#!/bin/sh
source "../../common/init.sh"

get https://docbook.org/xml/${PV}/docbook-${PV}.zip
acheck

cd docbook-$PV

mkdir -p "${D}/pkg/main/${PKG}.sgml.${PVR}/docbook"/schema/{dtd,rng,sch,xsd}/5.0

install -vm644  dtd/* "${D}/pkg/main/${PKG}.sgml.${PVR}/docbook/schema/dtd/5.0"
install -vm644  rng/* "${D}/pkg/main/${PKG}.sgml.${PVR}/docbook/schema/rng/5.0"
install -vm644  sch/* "${D}/pkg/main/${PKG}.sgml.${PVR}/docbook/schema/sch/5.0"
install -vm644  xsd/* "${D}/pkg/main/${PKG}.sgml.${PVR}/docbook/schema/xsd/5.0"

finalize
