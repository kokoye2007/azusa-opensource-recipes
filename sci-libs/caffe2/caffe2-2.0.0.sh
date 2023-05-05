#!/bin/sh
source ../../common/init.sh
inherit python

PYTHON_RESTRICT="$PYTHON_LATEST"

# pytorch does not support cuda 12 yet, and not even 11.8
CUDA_VERSION="11.7"
# query cuda-config to find supported gcc versions
GCC_VERSIONS="$(/pkg/main/dev-util.nvidia-cuda-toolkit.core.$CUDA_VERSION/bin/cuda-config -s)"
for vers in $GCC_VERSIONS; do
	if [ -e /pkg/main/sys-devel.gcc.core.$vers/bin/gcc ]; then
		GCC_VERSION="$vers"
	fi
done

echo " * Using CUDA_VERSION=$CUDA_VERSION and GCC_VERSION=$GCC_VERSION"

get https://github.com/pytorch/pytorch/releases/download/v${PV}/pytorch-v${PV}.tar.gz ${P}.tar.gz
acheck

importpkg sys-process/numactl dev-util/nvidia-cuda-toolkit:$CUDA_VERSION dev-lang/python dev-libs/cudnn dev-libs/gmp dev-libs/mpfr sci-libs/fftw dev-cpp/tbb dev-libs/protobuf media-libs/nv-codec-headers dev-cpp/eigen sci-libs/onnx dev-libs/sleef dev-libs/FP16

# force gcc-$GCC_VERSION
export PATH="/pkg/main/sys-devel.gcc.core.$GCC_VERSION/bin:/pkg/main/dev-util.nvidia-cuda-toolkit.core.$CUDA_VERSION/bin:$PATH"
rm -f /usr/bin/gcc /usr/bin/g++ /usr/bin/nvcc

cd "${T}"

# https://docs.nvidia.com/cuda/cuda-compiler-driver-nvcc/
export NVCC_PREPEND_FLAGS="-L/pkg/main/dev-util.nvidia-cuda-toolkit.libs.$CUDA_VERSION/lib$LIB_SUFFIX"

CUDALIB="/pkg/main/dev-util.nvidia-cuda-toolkit.libs.$CUDA_VERSION/lib$LIB_SUFFIX"

cudalib() {
	# find full name of lib
	# eg. /pkg/main/dev-util.nvidia-cuda-toolkit.libs.11.7.0.linux.amd64/lib64/libcudart.so.11.7.60
	realpath "$CUDALIB/$1"
}

OPTS=(
	-DCUDA_INCLUDE_DIRS=/pkg/main/dev-util.nvidia-cuda-toolkit.dev.$CUDA_VERSION/include
	-DCUDA_CUDA_LIB="$CUDALIB/stubs/libcuda.so"
	-DCUDA_CUDART_LIBRARY="$(cudalib libcudart.so)"
	-DCUDA_NVRTC_LIB="$(cudalib libnvrtc.so)"
	-DCUDA_cublas_LIBRARY="$(cudalib libcublas.so)"
	-DCUDA_cublasLt_LIBRARY="$(cudalib libcublasLt.so)"
	-DCUDA_cufft_LIBRARIES="$(cudalib libcufft.so)"
	-DCUDA_curand_LIBRARY="$(cudalib libcurand.so)"

	-DBUILD_CUSTOM_PROTOBUF=OFF
	-DBUILD_SHARED_LIBS=ON

	-DUSE_CCACHE=OFF
	-DUSE_CUDA=ON
	-DUSE_CUDNN=ON
	-DUSE_FAST_NVCC=ON
	#-DTORCH_CUDA_ARCH_LIST="3.5 7.0"
	-DBUILD_NVFUSER=OFF
	# -DUSE_DISTRIBUTED=ON # todo tensorpipe
	-DUSE_MPI=OFF # openmpi + ensorpipe etc
	-DUSE_FAKELOWP=OFF
	#-DUSE_FBGEMM=
	-DUSE_FFMPEG=ON
	-DUSE_GFLAGS=ON
	-DUSE_GLOG=ON
	-DUSE_GLOO=OFF
	-DUSE_KINETO=OFF # TODO
	-DUSE_LEVELDB=OFF
	-DUSE_MAGMA=OFF # TODO: In GURU as sci-libs/magma
	-DUSE_MKLDNN=OFF
	-DUSE_NCCL=OFF # TODO: NVIDIA Collective Communication Library

	# TODO
	-DUSE_NNPACK=OFF
	-DUSE_QNNPACK=OFF
	-DUSE_XNNPACK=OFF
	-DUSE_SYSTEM_XNNPACK=OFF
	-DUSE_TENSORPIPE=OFF
	-DUSE_PYTORCH_QNNPACK=OFF

	-DUSE_NUMPY=ON
	-DUSE_OPENCL=ON
	# -DUSE_OPENCV=ON # FIXME
	-DUSE_OPENMP=ON
	-DUSE_ROCM=OFF # TODO
	#-DUSE_SYSTEM_CPUINFO=ON
	#-DUSE_SYSTEM_PYBIND11=ON # TODO
	-DUSE_UCC=OFF
	-DUSE_VALGRIND=OFF
	-DPYBIND11_PYTHON_VERSION="$PYTHON_LATEST"
	-DPYTHON_EXECUTABLE="/pkg/main/dev-lang.python.core.${PYTHON_LATEST}/bin/python${PYTHON_LATEST%.*}"
	-DUSE_ITT=OFF
	-DBLAS=Eigen # avoid the use of MKL, if found on the system
	-DUSE_SYSTEM_EIGEN_INSTALL=ON
	-DEigen3_DIR=/pkg/main/dev-cpp.eigen.core/share/eigen3/cmake
	-DUSE_SYSTEM_PTHREADPOOL=ON
	-DUSE_SYSTEM_FXDIV=ON
	#-DUSE_SYSTEM_FP16=ON # pytorch cannot use fp16.h outside of /usr/include/fp16.h
	-DUSE_SYSTEM_GLOO=ON
	-DUSE_SYSTEM_ONNX=ON
	-DUSE_SYSTEM_SLEEF=ON

	-Wno-dev
	-DTORCH_INSTALL_LIB_DIR="/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX"
	-DLIBSHM_INSTALL_LIB_SUBDIR="/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX"

	# -DCMAKE_CUDA_FLAGS=""
)

docmake "${OPTS[@]}"

# prepare the stuff we need to build torch
mkdir -pv "${D}/pkg/main/${PKG}.dev.${PVRF}/torch_build"
cp -v CMakeCache.txt "${D}/pkg/main/${PKG}.dev.${PVRF}/torch_build"
cp -v "${S}/torch/version.py" "${D}/pkg/main/${PKG}.dev.${PVRF}/torch_build" || /bin/bash -i

finalize
