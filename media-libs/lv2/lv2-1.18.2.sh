#!/bin/sh
source "../../common/init.sh"
inherit waf

get http://lv2plug.in/spec/${P}.tar.bz2
acheck

cd "${T}"

dowaf

finalize
