#!/bin/sh
source "../../common/init.sh"

MY_P=${P/-mpi}
get http://www.open-mpi.org/software/ompi/v"${PV%.*}"/downloads/"${MY_P}".tar.bz2
acheck

cd "${T}" || exit

doconf

make
make install DESTDIR="${D}"

finalize
