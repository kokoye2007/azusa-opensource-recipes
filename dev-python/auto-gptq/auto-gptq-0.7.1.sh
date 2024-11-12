#!/bin/sh
source ../../common/init.sh
inherit python
inherit cuda

# empty CPPFLAGS since nvcc won't support -pipe etc
CPPFLAGS=""

initcuda 11.8

importpkg sci-libs/caffe2 dev-cpp/gflags

# https://github.com/pytorch/pytorch/blob/main/torch/utils/cpp_extension.py#L1959
# auto-gptq requires 7.5 minimum
export TORCH_CUDA_ARCH_LIST="7.5;8.0;9.0+PTX"

# pytorch will not honor CPPFLAGS, so pass that directly to nvcc instead
export PYTORCH_NVCC="${CUDA_HOME}/bin/nvcc ${CPPFLAGS}"

cd "$WORKDIR" || exit

# download from github because missing files
# See: https://github.com/AutoGPTQ/AutoGPTQ/issues/594
get https://github.com/AutoGPTQ/AutoGPTQ/archive/refs/tags/v"${PV}".tar.gz "${P}".tar.gz
acheck

cd "${S}" || exit

pythonsetup
archive
