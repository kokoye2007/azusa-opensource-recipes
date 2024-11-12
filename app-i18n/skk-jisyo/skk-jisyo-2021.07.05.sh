#!/bin/sh
source "../../common/init.sh"

git clone --no-checkout https://github.com/skk-dev/dict.git 
cd dict || exit
git checkout -q "master@{${PV//./-}}"
acheck

# those are EUC-JP format
mkdir -p "${D}/pkg/main/${PKG}.core.${PVRF}/skk"
cp SKK-JISYO.* "${D}/pkg/main/${PKG}.core.${PVRF}/skk"

finalize
