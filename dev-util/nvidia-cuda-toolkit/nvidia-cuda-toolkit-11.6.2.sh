#!/bin/sh
source "../../common/init.sh"

DRIVER_PV="510.47.03"
cuda_supported_gcc="8.5 9.4 9.5 10.3 10.4 11.1 11.2 11.3"

get "https://developer.download.nvidia.com/compute/cuda/${PV}/local_installers/cuda_${PV}_${DRIVER_PV}_linux.run"
acheck

# extract this file (makeself 2.1*)
SRCFILE="cuda_${PV}_${DRIVER_PV}_linux.run"
skip_lines="$(grep -a offset=.*head.*wc "$SRCFILE" | awk '{ print $3 }' | head -n1)"
skip_bytes="$(head -n "$skip_lines" "$SRCFILE" | wc -c)"

# use dd the way gentoo does (I don't like this thing with ibs, but oh well, at least it works)
dd ibs="$skip_bytes" skip=1 if="$SRCFILE" of="${SRCFILE}.arch"

# let tar find out the right format
tar --no-same-owner -xf "${SRCFILE}.arch"

builddirs=(
	builds/cuda_{cccl,cudart,cuobjdump,cuxxfilt,memcheck,nvcc,nvdisasm,nvml_dev,nvprune,nvrtc,nvtx}
	builds/lib{cublas,cufft,curand,cusolver,cusparse,npp,nvjpeg}
	builds/cuda_nvcc/nvvm
	builds/cuda_nvml_dev/nvml
)

mkdir -p "${D}/pkg/main/${PKG}.core.${PVRF}"

for d in "${builddirs[@]}"; do
	echo "Installing ${d}"
	[[ -d ${d} ]] || die "Directory does not exist: ${d}"

	if [ -d "${d}/targets/x86_64-linux" ]; then
		if [ -d "${d}/targets/x86_64-linux/include" ]; then
			mkdir -p "${d}/include"
			rsync -av "${d}/targets/x86_64-linux/include/" "${d}/include/"
			rm -fr "${d}/targets/x86_64-linux/include"
		fi
		if [ -d "${d}/targets/x86_64-linux/lib" ]; then
			mkdir -p "${d}/lib64"
			rsync -av "${d}/targets/x86_64-linux/lib/" "${d}/lib64/"
			rm -fr "${d}/targets/x86_64-linux/lib"
		fi
		ls "${d}/targets/x86_64-linux"
		rmdir "${d}/targets/x86_64-linux"
	fi

	rsync -av "${d}/" "${D}/pkg/main/${PKG}.core.${PVRF}"
done

# targets typically contains what we already have (if any)
rm -fr "${D}/pkg/main/${PKG}.core.${PVRF}/targets" || true

# todo nsight

# cuda-config
sed -e "s:CUDA_SUPPORTED_GCC:${cuda_supported_gcc}:g" \
	"${FILESDIR}"/cuda-config.in > "${D}/pkg/main/${PKG}.core.${PVRF}/bin/cuda-config"
chmod -v +x "${D}/pkg/main/${PKG}.core.${PVRF}/bin/cuda-config"

finalize
