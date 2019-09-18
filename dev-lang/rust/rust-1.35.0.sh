#!/bin/sh
source "../../common/init.sh"

get https://static.rust-lang.org/dist/rustc-${PV}-src.tar.gz

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
docdir = "/pkg/main/${PKG}.doc.${PVR}"

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

export RUSTFLAGS="$RUSTFLAGS -C link-args=-lffi"

python3 ./x.py build --exclude src/tools/miri

export LIBSSH2_SYS_USE_PKG_CONFIG=1
DESTDIR="${D}" python3 ./x.py install
unset LIBSSH2_SYS_USE_PKG_CONFIG

finalize
