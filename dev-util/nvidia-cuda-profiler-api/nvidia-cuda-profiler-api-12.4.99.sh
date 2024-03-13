#!/bin/sh
source "../../common/init.sh"

# https://developer.download.nvidia.com/compute/cuda/redist/cuda_profiler_api/linux-x86_64/
get https://developer.download.nvidia.com/compute/cuda/redist/cuda_profiler_api/linux-x86_64/cuda_profiler_api-linux-x86_64-${PV}-archive.tar.xz
acheck

mkdir -p "${D}/pkg/main"
mv -v "${S}" "${D}/pkg/main/${PKG}.dev.${PVRF}"

archive
