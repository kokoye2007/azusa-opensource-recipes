#!/bin/sh
source "../../common/init.sh"

get https://sourceforge.net/projects/libjpeg-turbo/files/"${PV}"/"${P}".tar.gz
acheck

cd "${T}" || exit

docmake

finalize
