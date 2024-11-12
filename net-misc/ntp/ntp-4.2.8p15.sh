#!/bin/sh
source "../../common/init.sh"

get https://www.eecis.udel.edu/~ntp/ntp_spool/ntp4/ntp-"${PV%.*}"/"${P}".tar.gz
acheck

cd "${S}" || exit

apatch "$FILESDIR/0001-libntp-Do-not-use-PTHREAD_STACK_MIN-on-glibc.patch"
sed -e 's/"(\\S+)"/"?([^\\s"]+)"?/' -i scripts/update-leap/update-leap.in

cd "${T}" || exit

importpkg zlib libcap

doconf CFLAGS="-O2 -g -fPIC" --sysconfdir=/etc --enable-linuxcaps --with-lineeditlibs=readline

make
make install DESTDIR="${D}"

finalize
