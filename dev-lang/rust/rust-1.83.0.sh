#!/bin/sh
source "../../common/init.sh"

get https://static.rust-lang.org/dist/rustc-${PV}-src.tar.gz
envcheck

importpkg zlib sys-libs/llvm-libunwind dev-libs/libffi

cd "rustc-${PV}-src"

# https://github.com/rust-lang/rust/blob/master/config.example.toml
# AArch64;AMDGPU;ARM;AVR;BPF;Hexagon;Lanai;LoongArch;Mips;MSP430;NVPTX;PowerPC;RISCV;Sparc;SystemZ;VE;WebAssembly;X86;XCore
#
# We use sys-devel/llvm-full since it should be easier
export PATH="/pkg/main/sys-devel.llvm-full.core/bin:$PATH"

cat << EOF > config.toml
change-id = 118703

[llvm]
# llvm won't be compiled by rust since we provide llvm-config in targets below
#download-ci-llvm = false
#optimize = true
#release-debuginfo = false
#assertions = false
#targets = "X86;AArch64;ARM;WebAssembly"
#experimental-targets = ""

# When using system llvm prefer shared libraries
#link-shared = true

[build]
build-stage = 2
test-stage = 2

# omit docs to save time and space (default is to build them)
docs = false
compiler-docs = false
submodules = false
python = "python3"
locked-deps = true
vendor = true
verbose = 2
sanitizers = false
cargo-native-static = false

# install cargo as well as rust
extended = true

[install]
prefix = "/pkg/main/${PKG}.core.${PVRF}"
sysconfdir = "etc"
docdir= "/pkg/main/${PKG}.doc.${PVRF}/rust"
bindir = "bin"
libdir = "/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX"
mandir = "/pkg/main/${PKG}.doc.${PVRF}/man"

[rust]
codegen-units-std = 1
optimize = true
debug = false
debug-assertions = false
debug-assertions-std = false
debuginfo-level = 0
debuginfo-level-rustc = 0
debuginfo-level-std = 0
debuginfo-level-tools = 0
debuginfo-level-tests = 0

backtrace = true
incremental = false

channel = "stable"
description = "azusa"
rpath = false
verbose-tests = true
optimize-tests = true
dist-src = false
remap-debuginfo = true
backtrace-on-ice = true
jemalloc = false

# BLFS does not install the FileCheck executable from llvm,
# so disable codegen tests
codegen-tests = false

[dist]
src-tarball = false
compression-formats = ["xz"]

#[target.x86_64-unknown-linux-gnu]
#llvm-config = "/pkg/main/sys-devel.llvm-full.core/bin/llvm-config"
#ar = "ar"
#cc = "clang++"
#cxx = "clang++"
#linker = "clang++"
#ranlib = "ranlib"
#llvm-libunwind = "system"
#
#[target.i686-unknown-linux-gnu]
#llvm-config = "/pkg/main/sys-devel.llvm-full.core/bin/llvm-config"
#ar = "ar"
#cc = "clang++"
#cxx = "clang++"
#linker = "clang++"
#ranlib = "ranlib"
#llvm-libunwind = "system"
#
#[target.wasm32-unknown-unknown]
#linker = "lld"
#profiler = false
EOF

export LLVM_LINK_SHARED=1
export RUSTFLAGS="$RUSTFLAGS -C link-arg=-fuse-ld=lld -C link-arg=-lffi -Lnative=$(/pkg/main/sys-devel.llvm-full.core/bin/llvm-config --libdir)"
export LIBGIT2_NO_VENDOR=1

# this is a literally magic variable that gets through cargo cache, without it some
# crates ignore RUSTFLAGS.
# this variable can not contain leading space.
export MAGIC_EXTRA_RUSTFLAGS="-L/pkg/main/sys-libs.llvm-libunwind.libs/lib$LIB_SUFFIX"

echo "Using RUSTFLAGS = $RUSTFLAGS"

# attempt to make libssh2 work, see https://github.com/rust-lang/rust/issues/69552
# giving up on libssh2 and libgit 

# Alternatively, this works too:
export DEP_Z_INCLUDE=`pkg-config --variable=includedir zlib`
export DEP_OPENSSL_INCLUDE=`pkg-config --variable=includedir openssl`

# to avoid errors such as
# thread 'main' panicked at 'could not canonicalize /pkg/main/dev-lang.rust.core.1.35.0', src/bootstrap/install.rs:71:48
mkdir -p "/pkg/main/${PKG}.core.${PVRF}"

echo "Running python3 ./x.py build"
python3 ./x.py build

echo "Running DESTDIR=$D python3 ./x.py install"
DESTDIR="${D}" python3 ./x.py install || /bin/bash -i

# add +x flag on libs so ldconfig indexes these
chmod -v +x "${D}/pkg/main/${PKG}.libs.${PVRF}"/lib*/*.so


finalize
