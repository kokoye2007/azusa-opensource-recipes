#!/bin/sh
source "../../common/init.sh"

get https://github.com/ipmitool/ipmitool/releases/download/IPMITOOL_1_8_18/${P}.tar.bz2
acheck

importpkg tinfo sys-libs/readline openssl

cd "${T}"

doconf --enable-intf-lan --enable-intf-usb --enable-intf-lanplus --enable-intf-serial --with-kerneldir=/pkg/main/sys-kernel.linux.dev --enable-intf-free --enable-intf-open --enable-intf-imb --enable-ipmishell --enable-file-security

make
make install DESTDIR="${D}"

finalize
