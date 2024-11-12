#!/bin/sh
source "../../common/init.sh"

get https://dl.matroska.org/downloads/"${PN}"/"${P}".tar.xz
acheck

cd "${T}" || exit

docmake -DBUILD_SHARED_LIBS=YES

finalize
