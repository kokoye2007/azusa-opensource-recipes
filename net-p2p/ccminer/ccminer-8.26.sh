#!/bin/sh
source "../../common/init.sh"

get https://github.com/KlausT/ccminer/archive/refs/tags/${PV}.tar.gz ${P}.tar.gz
acheck

inherit cuda
initcuda 12.2

cd "${S}"

# remove deprecated & now unsupported archs
sed -i '/^nvcc_ARCH.*compute_37/d;/^nvcc_ARCH.*compute_35/d' Makefile.am
sed -i 's/-gencode=arch=compute_35,code=sm_35//;s/-gencode=arch=compute_37,code=sm_37//' Makefile.am

aautoreconf

cd "${T}"

importpkg dev-libs/openssl net-misc/curl

export CFLAGS="${CFLAGS} -ftrivial-auto-var-init=zero"

doconf

echo "make NVCC=\"nvcc -I${S}\""
/bin/bash -i; exit 1
make NVCC="nvcc -I${S}"
make install DESTDIR="${D}"

# move ccminer and replace with a wrapper script that preloads cudapreload
mkdir -p "${D}/pkg/main/${PKG}.core.${PVRF}/libexec"
mv -v "${D}/pkg/main/${PKG}.core.${PVRF}/bin/ccminer" "${D}/pkg/main/${PKG}.core.${PVRF}/libexec/ccminer"
cat >"${D}/pkg/main/${PKG}.core.${PVRF}/bin/ccminer" <<'EOF'
#!/bin/sh
export LD_PRELOAD=/pkg/main/sys-libs.cudapreload.dev/lib64/cudapreload.so
exec "$(dirname "$0")/../libexec/ccminer" "$@"
EOF
chmod +x "${D}/pkg/main/${PKG}.core.${PVRF}/bin/ccminer"

finalize
