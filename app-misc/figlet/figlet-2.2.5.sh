#!/bin/sh
source "../../common/init.sh"

get ftp://ftp.figlet.org/pub/figlet/program/unix/"${P}".tar.gz
acheck

cd "${P}" || exit

PREFIX="/pkg/main/${PKG}.core.${PVRF}"
make prefix="$PREFIX" all
make prefix="$PREFIX" DESTDIR="${D}" BINDIR="$PREFIX/bin" MANDIR="/pkg/main/${PKG}.doc.${PVRF}/man" install

finalize
