#!/bin/sh
source "../../common/init.sh"

get https://github.com/${PN}/${PN}/archive/${MYP}.tar.gz "${P}.tar.gz"
acheck

cd "${T}"

docmake -DLIBHPDF_EXAMPLES=NO -DLIBHPDF_STATIC=NO

finalize
