#!/bin/sh
source "../../common/init.sh"

get https://github.com/RadeonOpenCompute/ROCT-Thunk-Interface/archive/rocm-"${PV}".tar.gz "${P}".tar.gz
acheck

cd "${T}" || exit

importpkg sys-process/numactl

docmake

finalize
