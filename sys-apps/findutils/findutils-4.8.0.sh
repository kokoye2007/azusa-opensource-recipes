#!/bin/sh
source "../../common/init.sh"

get http://ftp.gnu.org/pub/gnu/"${PN}"/"${P}".tar.xz
acheck

cd "${P}" || exit

sed -i 's/IO_ftrylockfile/IO_EOF_SEEN/' gl/lib/*.c
sed -i '/unistd/a #include <sys/sysmacros.h>' gl/lib/mountlist.c
echo "#define _IO_IN_BACKUP 0x100" >> gl/lib/stdio-impl.h

cd "${T}" || exit

doconf --localstatedir=/var/lib/locate

make
make install DESTDIR="${D}"

finalize
