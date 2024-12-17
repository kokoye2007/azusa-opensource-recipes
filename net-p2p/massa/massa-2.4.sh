#!/bin/sh
source "../../common/init.sh"

get https://github.com/massalabs/massa/archive/refs/tags/MAIN.${PV}.tar.gz "${P}.tar.gz"
envcheck

# required by librocksdb-sys
export LIBCLANG_PATH=/pkg/main/sys-devel.llvm-full.libs/lib$LIB_SUFFIX

# we keep networking alive for cargo
cd "${S}"
cargo build --release --workspace

for foo in massa-node massa-client; do
	cd "${S}/$foo"

	mkdir -p "${D}/pkg/main/${PKG}.core.${PVRF}/$foo"
	mv -v "../target/release/$foo" "${D}/pkg/main/${PKG}.core.${PVRF}/$foo/$foo"
	mv -v base_config config "${D}/pkg/main/${PKG}.core.${PVRF}/$foo"
	if [ -e storage ]; then
		mv -v storage "${D}/pkg/main/${PKG}.core.${PVRF}/$foo"
	fi
done

mkdir -p "${D}/pkg/main/${PKG}.core.${PVRF}/bin"
cp "$FILESDIR/massa-node" "${D}/pkg/main/${PKG}.core.${PVRF}/bin"
chmod +x "${D}/pkg/main/${PKG}.core.${PVRF}/bin/massa-node"
ln -snf massa-node "${D}/pkg/main/${PKG}.core.${PVRF}/bin/massa-client"

finalize
