#!/bin/sh
source "../../common/init.sh"
inherit waf

get http://download.drobilla.net/${P}.tar.bz2
acheck

cd "${T}"

importpkg zlib

dowaf

finalize
