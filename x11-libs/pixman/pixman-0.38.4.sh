#!/bin/sh
source "../../common/init.sh"

get https://www.cairographics.org/releases/"${P}".tar.gz

cd "${T}" || exit

meson --prefix="/pkg/main/${PKG}.core.${PVRF}" "${CHPATH}/${P}"

ninja
DESTDIR="${D}" ninja install

finalize
