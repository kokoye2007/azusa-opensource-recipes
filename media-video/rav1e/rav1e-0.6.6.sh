#!/bin/sh
source "../../common/init.sh"

get https://github.com/xiph/rav1e/archive/v"${PV}".tar.gz
envcheck

cd "${S}" || exit

importpkg zlib sys-libs/llvm-libunwind

# see https://github.com/lu-zero/cargo-c/issues/347 for issues related to passing RUSTFLAGS to cargo-cbuild

# replace rustc with a wrapper because cargo-cbuild seems to block any rustflags
rm /bin/rustc
cat >/bin/rustc <<EOF
#!/bin/sh
exec /pkg/main/dev-lang.rust.core/bin/rustc $RUSTFLAGS "\$@"
EOF
chmod +x /bin/rustc

# this doesn't work
# export CARGO_TARGET_X86_64_UNKNOWN_LINUX_GNU_RUSTFLAGS="$RUSTFLAGS"

cargo build --release
echo "running cbuild"
cargo cbuild --release --target-dir="capi" --prefix="/pkg/main/${PKG}.core.${PVRF}" --libdir="/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX" -v
echo "running cinstall"
cargo cinstall --release --target-dir="capi" --prefix="/pkg/main/${PKG}.core.${PVRF}" --libdir="/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX" --destdir="${D}"


finalize
