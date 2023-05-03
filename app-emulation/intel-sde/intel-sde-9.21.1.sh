#!/bin/sh
source "../../common/init.sh"

get https://downloadmirror.intel.com/777395/sde-external-${PV}-2023-04-24-lin.tar.xz
acheck

mkdir -p "${D}/pkg/main/${PKG}.core.${PVRF}/bin"
mv -v "${S}" "${D}/pkg/main/${PKG}.data.${PVRF}"

for foo in sde sde64 xed xed64; do
	cat >"${D}/pkg/main/${PKG}.core.${PVRF}/bin/$foo" <<EOF
#!/bin/sh
exec /pkg/main/${PKG}.data.${PVRF}/${foo} "\$@"
EOF
	chmod +x "${D}/pkg/main/${PKG}.core.${PVRF}/bin/$foo"
done

fixelf
archive
