#!/bin/sh
source "../../common/init.sh"

inherit llvm

if [ ! -d /pkg/main/sys-libs.compiler-rt.libs.${PVRF}/lib$LIB_SUFFIX ]; then
	echo "compiler-rt for this version needs to be compiled first"
	exit 1
fi

llvmget clang clang-tools-extra

# disable amdgpu-arch
sed -i '/amdgpu/d' "${S}/tools/CMakeLists.txt"

acheck

importpkg zlib

cd "${T}"

OPTS=(
	-DLLVM_ENABLE_TERMINFO=ON
	-DLLVM_ENABLE_LIBXML2=ON
	-DLLVM_ENABLE_EH=ON
	-DLLVM_ENABLE_RTTI=ON
	-DLLVM_APPEND_VC_REV=OFF
	-DBUILD_SHARED_LIBS=ON
	-DCLANG_DEFAULT_OPENMP_RUNTIME=libomp
	-DCMAKE_DISABLE_FIND_PACKAGE_hsa-runtime64=ON
	# enable static analyzer
	-DCLANG_ENABLE_ARCMT=ON
	-DCLANG_ENABLE_STATIC_ANALYZER=ON

	-DCLANG_DEFAULT_CXX_STDLIB="libc++"
	-DCLANG_DEFAULT_RTLIB="compiler-rt"
	-DCLANG_DEFAULT_UNWINDLIB="libunwind"
	-DCMAKE_CXX_STANDARD_LIBRARIES="-ldl"
	-DCLANG_CONFIG_FILE_SYSTEM_DIR="/pkg/main/${PKG}.core.${PVRF}/config"

	-DDEFAULT_SYSROOT="/pkg/main/sys-libs.glibc.dev"
	-DC_INCLUDE_DIRS="/pkg/main/sys-libs.glibc.dev.${OS}.${ARCH}/include"
	#-DCLANG_PYTHON_BINDINGS_VERSIONS=""

	# /build/clang-16.0.2/work/clang-tools-extra/pseudo/tool/HTMLForest.cpp:57:10: fatal error: HTMLForestResources.inc: No such file or directory
	#-DLLVM_EXTERNAL_CLANG_TOOLS_EXTRA_SOURCE_DIR="${WORKDIR}/clang-tools-extra"

	# disable clang plugins because of:
	# /usr/bin/ld: cannot open linker script file /build/clang-16.0.2/temp/lib/Analysis/plugins/SampleAnalyzer/SampleAnalyzerPlugin.exports: No such file or directory
	-DCLANG_PLUGIN_SUPPORT=OFF

	-DCLANG_INCLUDE_TESTS=OFF
)

llvmbuild "${OPTS[@]}" || /bin/bash -i

# /pkg/main/sys-devel.clang.core.16.0.2.linux.amd64/lib64/clang/16/lib/linux/libclang_rt.builtins-x86_64.a
# this file is actually found as 
# /pkg/main/sys-libs.compiler-rt.libs.16.0.2.linux.amd64/lib64/linux/libclang_rt.builtins-x86_64.a
# clang_rt.crtbegin-x86_64.o  clang_rt.crtend-x86_64.o  libclang_rt.builtins-x86_64.a

ln -snf /pkg/main/sys-libs.compiler-rt.libs.$PVRF/lib$LIB_SUFFIX "${D}/pkg/main/${PKG}.core.${PVRF}/lib$LIB_SUFFIX/clang/${PV}/lib"
#ln -snf /pkg/main/sys-libs.compiler-rt.libs.$PVRF/lib$LIB_SUFFIX "${D}/pkg/main/${PKG}.core.${PVRF}/lib$LIB_SUFFIX/clang/${PV/.*}/lib"

# write config
mkdir -p "${D}/pkg/main/${PKG}.core.${PVRF}/config"
echo "@clang-common.cfg" >"${D}/pkg/main/${PKG}.core.${PVRF}/config/clang.cfg"
echo "@clang-common.cfg" >"${D}/pkg/main/${PKG}.core.${PVRF}/config/clang++.cfg"
echo "@clang-cxx.cfg" >>"${D}/pkg/main/${PKG}.core.${PVRF}/config/clang++.cfg"
echo "@clang-common.cfg" >"${D}/pkg/main/${PKG}.core.${PVRF}/config/clang-cpp.cfg"
echo "@clang-cxx.cfg" >>"${D}/pkg/main/${PKG}.core.${PVRF}/config/clang-cpp.cfg"

cat >"${D}/pkg/main/${PKG}.core.${PVRF}/config/clang-common.cfg" <<EOF
-L/pkg/main/sys-libs.llvm-libunwind.libs/lib$LIB_SUFFIX
--rtlib=libgcc
--unwindlib=libgcc
-fuse-ld=bfd
EOF

# /pkg/main/sys-libs.glibc.dev.${OS}.${ARCH}/include/c++/v1

cat >"${D}/pkg/main/${PKG}.core.${PVRF}/config/clang-cxx.cfg" <<EOF
--stdlib=libstdc++

# fix clang include path order
-nostdinc
-isystem /pkg/main/sys-libs.libcxx.dev/include/c++/v1
-isystem /pkg/main/sys-libs.glibc.dev.linux.amd64/include
-isystem /pkg/main/${PKG}.core.${PVRF}/lib64/clang/${PV/.*}/include

# fix libcxx libs include
-L/pkg/main/sys-libs.libcxx.libs/lib$LIB_SUFFIX
-L/pkg/main/sys-libs.libcxxabi.libs/lib$LIB_SUFFIX
-lc++ -lc++abi
EOF

# TODO --gcc-install-dir= ?

finalize
