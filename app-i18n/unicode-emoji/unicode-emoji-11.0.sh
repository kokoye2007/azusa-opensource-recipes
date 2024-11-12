#!/bin/sh
source "../../common/init.sh"

mkdir -p "${D}/pkg/main/${PKG}.core.${PVRF}/share/unicode/emoji"
cd "${D}/pkg/main/${PKG}.core.${PVRF}/share/unicode/emoji" || exit

for foo in data sequences test variation-sequences zwj-sequences; do
	get http://www.unicode.org/Public/emoji/"${PV}"/emoji-${foo}.txt
done

archive
