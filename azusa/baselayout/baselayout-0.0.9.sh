#!/bin/sh
source ../../common/init.sh

get https://github.com/AzusaOS/azusa-baselayout/archive/v${PV}.tar.gz

mkdir -p "${D}/pkg/main/${PKG}.core.${PVRF}"
rsync -av "azusa-${P}/" "${D}/pkg/main/${PKG}.core.${PVRF}/"

archive
