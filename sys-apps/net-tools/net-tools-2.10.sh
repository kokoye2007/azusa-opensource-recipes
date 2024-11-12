#!/bin/sh
source "../../common/init.sh"

get https://download.sourceforge.net/"${PN}"/"${P}".tar.xz
acheck

cd "${S}" || exit

# go with the default options
yes '' | ./configure.sh config.in
make all
make installbin DESTDIR="${D}/pkg/main/${PKG}.core.${PVRF}"
make -C man install BASEDIR="${D}" mandir="/pkg/main/${PKG}.doc.${PVRF}"
make -C po install INSTALLNLSDIR="${D}/pkg/main/${PKG}.core.${PVRF}/share/locale"

finalize
