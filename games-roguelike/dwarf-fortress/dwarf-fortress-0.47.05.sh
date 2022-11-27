#!/bin/sh
source "../../common/init.sh"

MY_PV="${PV/0.}"
MY_PV="${MY_PV/./_}"

get http://www.bay12games.com/dwarves/df_${MY_PV}_linux.tar.bz2
acheck

mkdir -p "${D}/pkg/main/${PKG}.core.${PVRF}/bin"
mv df_linux "${D}/pkg/main/${PKG}.data.${PVRF}"
cat >"${D}/pkg/main/${PKG}.core.${PVRF}/bin/dwarf-fortress" <<EOF
#!/bin/bash
cd "/pkg/main/${PKG}.data.${PVRF}"
exec ./df "$@"
EOF

finalize
