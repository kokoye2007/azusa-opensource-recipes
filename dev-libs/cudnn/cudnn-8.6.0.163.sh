#!/bin/sh
source "../../common/init.sh"

# supports 11.x but URL has a specific version number
CUDA_MA="11"
CUDA_MI="8"
CUDA_V="${CUDA_MA}.${CUDA_MI}"

get https://developer.download.nvidia.com/compute/redist/cudnn/v"${PV%.*}"/local_installers/${CUDA_V}/cudnn-linux-x86_64-"${PV}"_cuda${CUDA_MA}-archive.tar.xz
acheck

cd "${S}" || exit

mkdir -pv "${D}/pkg/main/${PKG}.core.${PVRF}"

mv -v * "${D}/pkg/main/${PKG}.core.${PVRF}"

finalize
