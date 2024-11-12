#!/bin/sh
source "../../common/init.sh"

get https://people.freedesktop.org/~hughsient/releases/"${P}".tar.xz
acheck

cd "${T}" || exit

meson --prefix="/pkg/main/${PKG}.core.${PVRF}" -Ddocs=false "${CHPATH}/${P}"

ninja
DESTDIR="${D}" ninja install

finalize
