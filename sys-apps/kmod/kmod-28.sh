#!/bin/sh
source "../../common/init.sh"

get https://mirrors.edge.kernel.org/pub/linux/utils/kernel/kmod/"${P}".tar.xz
acheck

cd "${T}" || exit

importpkg liblzma zlib

doconf --with-xz --with-zlib

make
make install DESTDIR="${D}"

# fix kmod
cd "${D}/pkg/main/${PKG}.core.${PVRF}/bin" || exit
ln -snfv kmod lsmod
mkdir ../sbin
cd ../sbin || exit

for target in depmod insmod lsmod modinfo modprobe rmmod; do
	ln -snfv ../bin/kmod $target
done

finalize
