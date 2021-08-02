#!/bin/sh
source "../../common/init.sh"

get https://github.com/lsof-org/${PN}/releases/download/${PV}/${PN}_${PV}.linux.tar.bz2
acheck

cd "${S}"

./Configure -n linux
make

mkdir -p "${D}/pkg/main/${PKG}.core.${PVRF}/bin" "${D}/pkg/main/${PKG}.doc.${PVRF}/man/man8"

install -v -m0755 lsof "${D}/pkg/main/${PKG}.core.${PVRF}/bin"
install -v lsof.8 "${D}/pkg/main/${PKG}.doc.${PVRF}/man/man8"

finalize
