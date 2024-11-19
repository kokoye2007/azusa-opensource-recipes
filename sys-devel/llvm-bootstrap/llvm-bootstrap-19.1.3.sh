#!/bin/sh
source "../../common/init.sh"
# this is only the base llvm

inherit llvm

llvmget _llvm
acheck

cd "${T}"

importpkg libxml-2.0 icu-uc sci-mathematics/z3 zlib sys-libs/llvm-libunwind sys-libs/libcxx sys-libs/libcxxabi

# importpkg will set CPPFLAGS but that's not read by llvm
export CFLAGS="${CPPFLAGS}"
export CXXFLAGS="${CPPFLAGS}"

unset CC CXX

# https://llvm.org/docs/CMake.html

CMAKE_OPTS=(
	-DCMAKE_BUILD_TYPE=Release
	-DCMAKE_INSTALL_PREFIX="/pkg/main/${PKG}.mod.${PVRF}" # use mod to avoid addition to PATH

	-DCMAKE_C_FLAGS="${CPPFLAGS} -O2"
	-DCMAKE_CXX_FLAGS="${CPPFLAGS} -O2"
	-DCMAKE_SYSTEM_INCLUDE_PATH="${CMAKE_SYSTEM_INCLUDE_PATH}"
	-DCMAKE_SYSTEM_LIBRARY_PATH="${CMAKE_SYSTEM_LIBRARY_PATH}"

	-DLLVM_ENABLE_PROJECTS="clang;lld" # bolt;clang;clang-tools-extra;compiler-rt;cross-project-tests;libc;libclc;lld;lldb;mlir;openmp;polly;pstl
	#-DLLVM_ENABLE_RUNTIMES="libcxxabi;libcxx;compiler-rt;openmp" # libc;libunwind;libcxxabi;pstl;libcxx;compiler-rt;openmp;llvm-libgcc;offload

	-DLLVM_HOST_TRIPLE="${CHOST}"

	-DLLVM_TARGETS_TO_BUILD="host" # AArch64;AMDGPU;ARM;AVR;BPF;Hexagon;Lanai;LoongArch;Mips;MSP430;NVPTX;PowerPC;RISCV;Sparc;SystemZ;VE;WebAssembly;X86;XCore

	-DLLVM_APPEND_VC_REV=OFF
	-DLLVM_LIBDIR_SUFFIX=$LIB_SUFFIX

	-DDEFAULT_SYSROOT="/pkg/main/sys-libs.glibc.dev"
	-DC_INCLUDE_DIRS="/pkg/main/sys-libs.glibc.dev.${OS}.${ARCH}/include"
	-DCLANG_CONFIG_FILE_SYSTEM_DIR="/pkg/main/${PKG}.mod.${PVRF}/config"
	-DCLANG_PLUGIN_SUPPORT=OFF

	-DBUILD_SHARED_LIBS=OFF # bootstrap, so let's build everything static
	-DLLVM_INCLUDE_TESTS=OFF
	-DLLVM_INCLUDE_BENCHMARKS=OFF
	-DLLVM_BUILD_TESTS=OFF

	# ffi requires extra info to be passed
	-DLLVM_ENABLE_FFI=ON
	-DFFI_INCLUDE_DIR=/pkg/main/dev-libs.libffi.dev/include
	-DFFI_LIBRARY_DIR=/pkg/main/dev-libs.libffi.libs/lib$LIB_SUFFIX

	# enable basic stuff
	-DLLVM_ENABLE_LIBEDIT=ON
	-DLLVM_ENABLE_TERMINFO=ON
	-DLLVM_ENABLE_LIBXML2=ON

	-DLLVM_ENABLE_EH=ON
	-DLLVM_ENABLE_RTTI=ON
	-DLLVM_ENABLE_Z3_SOLVER=ON
	-DLLVM_ENABLE_ZSTD=ON

	# stuff
	-DLLVM_BUILD_DOCS=ON
	-DLLVM_ENABLE_OCAMLDOC=OFF
	-DLLVM_ENABLE_SPHINX=OFF # TODO fix
	-DLLVM_ENABLE_DOXYGEN=OFF
	-DLLVM_INSTALL_UTILS=ON

	-DSPHINX_WARNINGS_AS_ERRORS=OFF
	-DLLVM_ENABLE_THREADS=ON

	-DPython3_EXECUTABLE=/bin/python3
)

# do not use llvmbuild since we are building llvm itself
# do not use docmake either since we want this to be contained in a mod dir
cmake -S "${S}" -B "${T}" -G Ninja -Wno-dev "${CMAKE_OPTS[@]}"
ninja -j"$NPROC" -v all
DESTDIR="${D}" ninja -j"$NPROC" -v install

# write config
mkdir -p "${D}/pkg/main/${PKG}.mod.${PVRF}/config"
echo "@clang-common.cfg" >"${D}/pkg/main/${PKG}.mod.${PVRF}/config/clang.cfg"
echo "@clang-common.cfg" >"${D}/pkg/main/${PKG}.mod.${PVRF}/config/clang++.cfg"
echo "@clang-cxx.cfg" >>"${D}/pkg/main/${PKG}.mod.${PVRF}/config/clang++.cfg"
echo "@clang-common.cfg" >"${D}/pkg/main/${PKG}.mod.${PVRF}/config/clang-cpp.cfg"
echo "@clang-cxx.cfg" >>"${D}/pkg/main/${PKG}.mod.${PVRF}/config/clang-cpp.cfg"

cat >"${D}/pkg/main/${PKG}.mod.${PVRF}/config/clang-common.cfg" <<EOF
--rtlib=libgcc
--unwindlib=libgcc
-fuse-ld=bfd
EOF

# /pkg/main/sys-libs.glibc.dev.${OS}.${ARCH}/include/c++/v1

cat >"${D}/pkg/main/${PKG}.mod.${PVRF}/config/clang-cxx.cfg" <<EOF
--stdlib=libstdc++

# fix clang include path order
-nostdinc
-isystem /pkg/main/sys-libs.libcxx.dev/include/c++/v1
-isystem /pkg/main/sys-libs.glibc.dev.linux.amd64/include
-isystem /pkg/main/${PKG}.mod.${PVRF}/lib${LIB_SUFFIX}/clang/${PV/.*}/include

# fix libcxx libs include
-L/pkg/main/sys-libs.libcxx.libs/lib$LIB_SUFFIX
-L/pkg/main/sys-libs.libcxxabi.libs/lib$LIB_SUFFIX
-lc++ -lc++abi
EOF

# TODO --gcc-install-dir= ?

fixelf
archive
