#!/bin/sh
source "../../common/init.sh"

get https://github.com/nlohmann/json/archive/v${PV}.tar.gz ${P}.tar.gz

PATCHES=(
	"${FILESDIR}"/${PN}-3.11.2-gcc13.patch
	"${FILESDIR}"/${PN}-3.11.2-gcc13-2.patch
)

cd "${S}"
apatch "${PATCHES[@]}"
acheck

cd "${T}"

docmake -DJSON_MultipleHeaders=ON -DJSON_BuildTests=OFF

finalize
