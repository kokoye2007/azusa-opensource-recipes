# CUDA related stuff

initcuda() {
	CUDA_VERSION="$1"
	if [ "$CUDA_VERSION" == "" ]; then
		CUDA_VERSION="11.8"
	fi

	# query cuda-config to find supported gcc versions
	GCC_VERSIONS="$(/pkg/main/dev-util.nvidia-cuda-toolkit.core."$CUDA_VERSION"/bin/cuda-config -s)"
	for vers in $GCC_VERSIONS; do
		if [ -e /pkg/main/sys-devel.gcc.core."$vers"/bin/gcc ]; then
			GCC_VERSION="$vers"
		fi
	done

	echo " * Using CUDA_VERSION=$CUDA_VERSION and GCC_VERSION=$GCC_VERSION"

	export CUDA_HOME=/pkg/main/dev-util.nvidia-cuda-toolkit.core.$CUDA_VERSION

	# force gcc-$GCC_VERSION
	if [ "$CUDA_OLD_PATH" = "" ]; then
		CUDA_OLD_PATH="$PATH"
	else
		PATH="$CUDA_OLD_PATH"
	fi
	export PATH="/pkg/main/sys-devel.gcc.core.$GCC_VERSION/bin:/pkg/main/dev-util.nvidia-cuda-toolkit.core.$CUDA_VERSION/bin:$PATH"
	rm -f /usr/bin/gcc /usr/bin/g++ /usr/bin/nvcc

	importpkg dev-util/nvidia-cuda-toolkit:"$CUDA_VERSION" dev-util/nvidia-cuda-profiler-api:"$CUDA_VERSION"
}
