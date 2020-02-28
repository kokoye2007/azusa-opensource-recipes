#!/bin/sh
source "../../common/init.sh"

get https://static.rust-lang.org/dist/rustc-${PV}-src.tar.gz
acheck

importpkg zlib

cd "rustc-${PV}-src"

cat << EOF > config.toml
[llvm]
targets = "X86"

# When using system llvm prefer shared libraries
link-shared = true

[build]
# omit docs to save time and space (default is to build them)
docs = false

# install cargo as well as rust
extended = true

[install]
prefix = "/pkg/main/${PKG}.core.${PVR}"

[rust]
channel = "stable"
rpath = false

# BLFS does not install the FileCheck executable from llvm,
# so disable codegen tests
codegen-tests = false

[target.x86_64-unknown-linux-gnu]
# NB the output of llvm-config (i.e. help options) may be
# dumped to the screen when config.toml is parsed.
llvm-config = "/pkg/main/sys-devel.llvm.dev/bin/llvm-config"

[target.i686-unknown-linux-gnu]
# NB the output of llvm-config (i.e. help options) may be
# dumped to the screen when config.toml is parsed.
llvm-config = "/pkg/main/sys-devel.llvm.dev/bin/llvm-config"
EOF

export RUSTFLAGS="$RUSTFLAGS -C link-arg=-L/pkg/main/dev-libs.libffi.libs/lib$LIB_SUFFIX -C link-arg=-lffi"

# to avoid errors such as
# thread 'main' panicked at 'could not canonicalize /pkg/main/dev-lang.rust.core.1.35.0', src/bootstrap/install.rs:71:48
mkdir "/pkg/main/${PKG}.core.${PVR}"

python3 ./x.py build --exclude src/tools/miri

export LIBSSH2_SYS_USE_PKG_CONFIG=1
python3 ./x.py install
unset LIBSSH2_SYS_USE_PKG_CONFIG

# move path to D for packaging
mkdir -p "${D}/pkg/main"
mv "/.pkg-main-rw/${PKG}.core.${PVR}" "${D}/pkg/main/${PKG}.core.${PVR}"

finalize
