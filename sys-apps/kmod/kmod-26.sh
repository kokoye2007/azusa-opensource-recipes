#!/bin/sh
source "../../common/init.sh"

get https://mirrors.edge.kernel.org/pub/linux/utils/kernel/kmod/${P}.tar.xz
acheck

cd "${T}"

importpkg liblzma zlib

doconf --with-xz --with-zlib

make
make install DESTDIR="${D}"

# fix kmod
cd "${D}/pkg/main/${PKG}.core.${PVR}/bin"
ln -snfv kmod lsmod
mkdir ../sbin
cd ../sbin

for target in depmod insmod lsmod modinfo modprobe rmmod; do
	ln -snfv ../bin/kmod $target
done

finalize
