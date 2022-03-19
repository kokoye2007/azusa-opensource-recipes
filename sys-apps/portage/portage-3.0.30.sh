#!/bin/sh
source "../../common/init.sh"
source ${ROOTDIR}/common/python.sh

PYTHON_RESTRICT="$PYTHON_LATEST"

get https://gitweb.gentoo.org/proj/portage.git/snapshot/${P}.tar.bz2
acheck

cd "${P}"

PORTAGE_OPTS=(
	--system-prefix="/pkg/main/${PKG}.core.${PVRF}"
	--system-exec-prefix="/pkg/main/${PKG}.core.${PVRF}"
	--bindir="/pkg/main/${PKG}.core.${PVRF}/bin"
	--docdir="/pkg/main/${PKG}.doc.${PVRF}"
	--mandir="/pkg/main/${PKG}.doc.${PVRF}/man"
)

pythonsetup "${PORTAGE_OPTS[@]}"

archive
