#!/bin/sh
source "../../common/init.sh"

get https://dl.matroska.org/downloads/${PN}/${P}.tar.xz
acheck

cd "${T}"

docmake -DBUILD_SHARED_LIBS=YES

finalize
