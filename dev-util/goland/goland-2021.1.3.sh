#!/bin/sh
source "../../common/init.sh"

get https://download.jetbrains.com/go/${P}.tar.gz
acheck

mkdir -p "${D}/pkg/main/${PKG}.core.${PVRF}/bin"
cat >"${D}/pkg/main/${PKG}.core.${PVRF}/bin/goland" <<EOF
#!/bin/sh
exec /pkg/main/${PKG}.data.${PVRF}/bin/goland.sh "$@"
EOF
chmod +x "${D}/pkg/main/${PKG}.core.${PVRF}/bin/goland"

mv -v "${S}" "${D}/pkg/main/${PKG}.data.${PVRF}"

finalize
