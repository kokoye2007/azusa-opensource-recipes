#!/bin/sh
source "../../common/init.sh"

get https://lv2plug.in/spec/"${P}".tar.xz
acheck

inherit asciidoc

cd "${T}" || exit

domeson

finalize
