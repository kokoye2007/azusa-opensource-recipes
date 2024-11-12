#!/bin/sh
source "../../common/init.sh"

get https://github.com/KhronosGroup/OpenCL-ICD-Loader/archive/refs/tags/v"${PV}".tar.gz "${P}".tar.gz
acheck

cd "${T}" || exit

docmake

finalize
