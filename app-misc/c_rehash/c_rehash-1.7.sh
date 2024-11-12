#!/bin/sh
source "../../common/init.sh"

get "https://cvs.pld-linux.org/cgi-bin/cvsweb.cgi/packages/openssl/openssl-c_rehash.sh?rev=${PV}" "openssl-c_rehash.sh.${PV}"
acheck

mkdir -p "${D}/pkg/main/${PKG}.core.${PVRF}/bin"
install -m755 openssl-c_rehash.sh."${PV}" "${D}/pkg/main/${PKG}.core.${PVRF}/bin/c_rehash"

finalize
