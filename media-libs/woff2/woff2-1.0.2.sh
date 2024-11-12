#!/bin/sh
source "../../common/init.sh"

get https://github.com/google/"${PN}"/archive/v"${PV}".tar.gz "${P}".tar.gz
acheck

cd "${T}" || exit

importpkg zlib

CMAKEOPTS=(
	-DCMAKE_SKIP_RPATH=ON # needed, causes QA warnings otherwise
	-DCANONICAL_PREFIXES=ON #661942
)

docmake "${CMAKEOPTS[@]}"

finalize
