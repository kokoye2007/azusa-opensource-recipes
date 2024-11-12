#!/bin/sh
source "../../common/init.sh"

get http://ftp.gnu.org/gnu/tar/"${P}".tar.bz2
acheck

cd "${T}" || exit

# note: we run this in a chroot, but could drop privileges during some parts of the process
export FORCE_UNSAFE_CONFIGURE=1
doconf

make
make install DESTDIR="${D}"

finalize
