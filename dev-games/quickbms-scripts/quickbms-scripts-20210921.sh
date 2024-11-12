#!/bin/sh
source "../../common/init.sh"

mkdir -p "${D}/pkg/main/${PKG}.data.${PVRF}/bms"
cd "${D}/pkg/main/${PKG}.data.${PVRF}/bms" || exit

get https://aluigi.altervista.org/quickbms_scripts.php "quickbms_scripts-${PV}.zip"

archive
