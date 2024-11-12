#!/bin/sh
source "../../common/init.sh"

get https://binaries.cockroachdb.com/cockroach-v"${PV}"."${OS}"-"${ARCH}".tgz

mkdir -p "${D}/pkg/main/${PKG}.core.${PVRF}/bin"

mv -v "${S}" "${D}/pkg/main/${PKG}.data.${PVRF}"

cat >"${D}/pkg/main/${PKG}.core.${PVRF}/bin/cockroach" <<EOF
#!/pkg/main/app-shells.bash.core/bin/bash
exec "/pkg/main/${PKG}.data.${PVRF}/cockroach" "\$@"
EOF
chmod -v +x "${D}/pkg/main/${PKG}.core.${PVRF}/bin/cockroach"

fixelf
archive
