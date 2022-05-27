#!/bin/sh
source "../../common/init.sh"

get https://static.rust-lang.org/dist/rustc-${PV}-src.tar.gz
envcheck

importpkg zlib

cd "rustc-${PV}-src"

cat << EOF > config.toml
[llvm]
targets = "X86"

# When using system llvm prefer shared libraries
link-shared = true

cflags="${CPPFLAGS} -O2"
cxxflags="${CPPFLAGS} -O2"
ldflags="${LDFLAGS}"

[build]
# omit docs to save time and space (default is to build them)
docs = false

# install cargo as well as rust
extended = true

[install]
prefix = "/pkg/main/${PKG}.core.${PVRF}"

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

export RUSTFLAGS="$RUSTFLAGS -C link-arg=-L/pkg/main/dev-libs.libffi.libs/lib$LIB_SUFFIX -C link-arg=-lffi -Lnative=$(llvm-config --libdir)"

# attempt to make libssh2 work, see https://github.com/rust-lang/rust/issues/69552
# giving up on libssh2 and libgit 

# Alternatively, this works too:
export DEP_Z_INCLUDE=`pkg-config --variable=includedir zlib`
export DEP_OPENSSL_INCLUDE=`pkg-config --variable=includedir openssl`

# to avoid errors such as
# thread 'main' panicked at 'could not canonicalize /pkg/main/dev-lang.rust.core.1.35.0', src/bootstrap/install.rs:71:48
mkdir -p "/pkg/main/${PKG}.core.${PVRF}"

python3 ./x.py build --exclude src/tools/miri

python3 ./x.py install

# move path to D for packaging
mkdir -p "${D}/pkg/main"
mv "/.pkg-main-rw/${PKG}.core.${PVRF}" "${D}/pkg/main/${PKG}.core.${PVRF}"

finalize
