#!/bin/sh
source "../../common/init.sh"

get https://github.com/libfuse/"${PN}"/releases/download/"${P}"/"${P}".tar.xz
acheck

cd "${T}" || exit

domeson

ninja
DESTDIR="${D}" ninja install

finalize
