#!/bin/sh
source "../../common/init.sh"

get https://github.com/drowe67/codec2/archive/v"${PV}".tar.gz "${P}".tar.gz
acheck

cd "${T}" || exit

docmake

finalize
