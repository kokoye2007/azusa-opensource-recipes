#!/bin/sh
source "../../common/init.sh"
inherit bazel

bazel_external_uris="
    https://github.com/bazelbuild/platforms/releases/download/0.0.2/platforms-0.0.2.tar.gz=bazelbuild-platforms-0.0.2.tar.gz
    https://github.com/bazelbuild/bazel-skylib/releases/download/1.0.3/bazel-skylib-1.0.3.tar.gz
    https://github.com/bazelbuild/bazel-toolchains/archive/dfc67056200b674accd08d8f9a21e328098c07e2.tar.gz=bazel-toolchains-dfc67056200b674accd08d8f9a21e328098c07e2.tar.gz
    https://github.com/bazelbuild/rules_android/archive/v0.1.1.zip=bazelbuild-rules_android-v0.1.1.zip
    https://github.com/bazelbuild/rules_cc/archive/40548a2974f1aea06215272d9c2b47a14a24e556.tar.gz=bazelbuild-rules_cc-40548a2974f1aea06215272d9c2b47a14a24e556.tar.gz
    https://github.com/bazelbuild/rules_closure/archive/308b05b2419edb5c8ee0471b67a40403df940149.tar.gz=bazelbuild-rules_closure-308b05b2419edb5c8ee0471b67a40403df940149.tar.gz
    https://github.com/bazelbuild/rules_docker/releases/download/v0.10.0/rules_docker-v0.10.0.tar.gz=bazelbuild-rules_docker-v0.10.0.tar.gz
    https://github.com/bazelbuild/rules_java/archive/7cf3cefd652008d0a64a419c34c13bdca6c8f178.zip=bazelbuild-rules_java-7cf3cefd652008d0a64a419c34c13bdca6c8f178.zip
    https://github.com/bazelbuild/rules_pkg/releases/download/0.2.5/rules_pkg-0.2.5.tar.gz=bazelbuild-rules_pkg-0.2.5.tar.gz
    https://github.com/bazelbuild/rules_proto/archive/a0761ed101b939e19d83b2da5f59034bffc19c12.zip=bazelbuild-rules_proto-a0761ed101b939e19d83b2da5f59034bffc19c12.zip
    https://github.com/bazelbuild/rules_python/releases/download/0.0.1/rules_python-0.0.1.tar.gz=bazelbuild-rules_python-0.0.1.tar.gz
    https://github.com/bazelbuild/rules_swift/releases/download/0.21.0/rules_swift.0.21.0.tar.gz=bazelbuild-rules_swift.0.21.0.tar.gz
    https://github.com/dmlc/dlpack/archive/3efc489b55385936531a06ff83425b719387ec63.tar.gz=dlpack-3efc489b55385936531a06ff83425b719387ec63.tar.gz
    https://github.com/google/farmhash/archive/0d859a811870d10f53a594927d0d0b97573ad06d.tar.gz=farmhash-0d859a811870d10f53a594927d0d0b97573ad06d.tar.gz
    https://github.com/google/gemmlowp/archive/fda83bdc38b118cc6b56753bd540caa49e570745.zip=gemmlowp-fda83bdc38b118cc6b56753bd540caa49e570745.zip
    https://github.com/google/highwayhash/archive/fd3d9af80465e4383162e4a7c5e2f406e82dd968.tar.gz=highwayhash-fd3d9af80465e4383162e4a7c5e2f406e82dd968.tar.gz
    https://github.com/google/re2/archive/506cfa4bffd060c06ec338ce50ea3468daa6c814.tar.gz=re2-506cfa4bffd060c06ec338ce50ea3468daa6c814.tar.gz
    https://github.com/google/ruy/archive/e6c1b8dc8a8b00ee74e7268aac8b18d7260ab1ce.zip=ruy-e6c1b8dc8a8b00ee74e7268aac8b18d7260ab1ce.zip
    https://github.com/joe-kuo/sobol_data/archive/835a7d7b1ee3bc83e575e302a985c66ec4b65249.tar.gz=sobol_data-835a7d7b1ee3bc83e575e302a985c66ec4b65249.tar.gz
    https://github.com/llvm/llvm-project/archive/55c71c9eac9bc7f956a05fa9258fad4f86565450.tar.gz=llvm-project-55c71c9eac9bc7f956a05fa9258fad4f86565450.tar.gz
    https://github.com/llvm/llvm-project/releases/download/llvmorg-10.0.1/openmp-10.0.1.src.tar.xz=llvmorg-10.0.1-openmp-10.0.1.src.tar.xz
    https://github.com/mborgerding/kissfft/archive/36dbc057604f00aacfc0288ddad57e3b21cfc1b8.tar.gz=kissfft-36dbc057604f00aacfc0288ddad57e3b21cfc1b8.tar.gz
    https://github.com/oneapi-src/oneDNN/archive/refs/tags/v2.5.1.tar.gz=oneDNN-v2.5.1.tar.gz
    https://github.com/petewarden/OouraFFT/archive/v1.0.tar.gz=OouraFFT-v1.0.tar.gz
    https://github.com/pytorch/cpuinfo/archive/5916273f79a21551890fd3d56fc5375a78d1598d.zip=pytorch-cpuinfo-5916273f79a21551890fd3d56fc5375a78d1598d.zip
    https://github.com/pytorch/cpuinfo/archive/d5e37adf1406cf899d7d9ec1d317c47506ccb970.tar.gz=pytorch-cpuinfo-d5e37adf1406cf899d7d9ec1d317c47506ccb970.tar.gz
    https://github.com/tensorflow/toolchains/archive/v1.3.2.tar.gz=tensorflow-toolchains-v1.3.2.tar.gz
    https://github.com/tensorflow/runtime/archive/c3e082762b7664bbc7ffd2c39e86464928e27c0c.tar.gz=tensorflow-runtime-c3e082762b7664bbc7ffd2c39e86464928e27c0c.tar.gz
    https://gitlab.com/libeigen/eigen/-/archive/085c2fc5d53f391afcccce21c45e15f61c827ab1/eigen-085c2fc5d53f391afcccce21c45e15f61c827ab1.tar.gz
    https://github.com/google/XNNPACK/archive/113092317754c7dea47bfb3cb49c4f59c3c1fa10.zip=XNNPACK-113092317754c7dea47bfb3cb49c4f59c3c1fa10.zip
    https://github.com/Maratyszcza/pthreadpool/archive/b8374f80e42010941bda6c85b0e3f1a1bd77a1e0.zip=pthreadpool-b8374f80e42010941bda6c85b0e3f1a1bd77a1e0.zip
    https://github.com/Maratyszcza/FP16/archive/4dfe081cf6bcd15db339cf2680b9281b8451eeb3.zip=FP16-4dfe081cf6bcd15db339cf2680b9281b8451eeb3.zip
    https://github.com/Maratyszcza/FXdiv/archive/63058eff77e11aa15bf531df5dd34395ec3017c8.zip=FXdiv-63058eff77e11aa15bf531df5dd34395ec3017c8.zip
"

bazel_get $bazel_external_uris

get https://github.com/${PN}/${PN}/archive/v${MY_PV}.tar.gz ${P}.tar.gz
get https://dev.gentoo.org/~perfinion/patches/tensorflow-patches-${PVR}.tar.bz2

cd "${S}"

apatch "${WORKDIR}/patches/"*.patch

# Relax version checks in setup.py
sed -i "/^    '/s/==/>=/g" tensorflow/tools/pip_package/setup.py
sed -i "/config_googleapis/d" tensorflow/workspace0.bzl

acheck

importpkg dev-cpp/abseil-cpp app-arch/snappy dev-libs/nsync dev-libs/double-conversion dev-libs/protobuf zlib

# bazel_load_distfiles "${bazel_external_uris}"

export JAVA_HOME="/pkg/main/dev-java.openjdk.core.linux.${ARCH}"

export CC_OPT_FLAGS=" "
export TF_ENABLE_XLA=0 # 1?
export TF_NEED_OPENCL_SYCL=0
export TF_NEED_OPENCL=0
export TF_NEED_COMPUTECPP=0
export TF_NEED_ROCM=0
export TF_NEED_MPI=1
export TF_SET_ANDROID_WORKSPACE=0

export PYTHON_BIN_PATH="$(which python)"
export PYTHON_LIB_PATH="$(python -c 'from distutils.sysconfig import *; print(get_python_lib())')"

export TF_NEED_CUDA=0 ## 1
export TF_DOWNLOAD_CLANG=0
export TF_CUDA_CLANG=0
export TF_NEED_TENSORRT=0

export CXXFLAGS+=" -std=c++17"
export BUILD_CXXFLAGS+=" -std=c++17"

# com_googlesource_code_re2 weird branch using absl, doesnt work with released re2
#com_github_googleapis_googleapis
	SYSLIBS=(
	absl_py
	astor_archive
	astunparse_archive
	boringssl
	com_github_googlecloudplatform_google_cloud_cpp
	com_github_grpc_grpc
	com_google_absl
	com_google_protobuf
	curl
	cython
	dill_archive
	double_conversion
	flatbuffers
	functools32_archive
	gast_archive
	gif
	hwloc
	icu
	jsoncpp_git
	libjpeg_turbo
	lmdb
	nasm
	nsync
	opt_einsum_archive
	org_sqlite
	pasta
	png
	pybind11
	six_archive
	snappy
	tblib_archive
	termcolor_archive
	typing_extensions_archive
	wrapt
	zlib
)

export TF_SYSTEM_LIBS="${SYSLIBS[@]}"
export TF_IGNORE_MAX_BAZEL_VERSION=1

# this is not autoconf
./configure

echo 'build --config=noaws --config=nohdfs' >> .bazelrc
echo 'build --define tensorflow_mkldnn_contraction_kernel=0' >> .bazelrc

abazel build -k --nobuild //tensorflow:libtensorflow_framework.so //tensorflow:libtensorflow.so //tensorflow:libtensorflow_cc.so # //tensorflow/tools/pip_package:build_pip_package
abazel build //tensorflow:libtensorflow_framework.so //tensorflow:libtensorflow.so
abazel build //tensorflow:libtensorflow_cc.so
abazel build //tensorflow/tools/pip_package:build_pip_package
abazel shutdown

abazel build //tensorflow:install_headers
abazel shutdown

# c/generate-pc.sh --prefix="${EPREFIX}"/usr --libdir=$(get_libdir) --version=${MY_PV}
# install *.pc

# bazel-bin/tensorflow/${l}

/bin/bash -i

finalize
