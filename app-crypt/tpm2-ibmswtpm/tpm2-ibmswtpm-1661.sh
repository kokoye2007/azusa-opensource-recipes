#!/bin/sh
source "../../common/init.sh"

get https://sourceforge.net/projects/ibmswtpm2/files/ibmtpm"${PV}".tar.gz
acheck

cd "${S}" || exit

# fix makefile
sed -i 's/^CCFLAGS +=.*/CCFLAGS += $(shell pkg-config --cflags openssl)/' makefile11
sed -i 's/LNFLAGS +=.*/LNFLAGS += $(shell pkg-config --libs openssl)/' makefile11

make -f makefile11

mkdir -p "${D}/pkg/main/${PKG}.core.${PVRF}/bin"
cp -a tpm_server "${D}/pkg/main/${PKG}.core.${PVRF}/bin"
cd ..
mkdir -p "${D}/pkg/main/${PKG}.doc.${PVRF}"
cp ibmtpm.doc LICENSE "${D}/pkg/main/${PKG}.doc.${PVRF}"

finalize
