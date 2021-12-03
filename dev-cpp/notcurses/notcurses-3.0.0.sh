#!/bin/sh
source "../../common/init.sh"

get https://github.com/dankamongmen/notcurses/archive/v${PV}.tar.gz ${P}.tar.gz
mkdir doc
cd doc
get https://github.com/dankamongmen/notcurses/releases/download/v${PV}/notcurses-doc-${PV}.tar.gz
acheck

cd "${T}"

importpkg dev-libs/libunistring zlib sys-libs/readline sys-libs/gpm app-arch/libdeflate

docmake -DUSE_DOCTEST=OFF -DUSE_GPM=ON -DUSE_MULTIMEDIA=ffmpeg -DUSE_PANDOC=OFF -DUSE_QRCODEGEN=OFF -DUSE_STATIC=OFF

cd "${WORKDIR}/doc"

for foo in 1 3; do
	mkdir -p "${D}/pkg/main/${PKG}.doc.${PVRF}/man/man$foo"
	mv -v *.$foo *."$foo.html" "${D}/pkg/main/${PKG}.doc.${PVRF}/man/man$foo"
done

finalize
