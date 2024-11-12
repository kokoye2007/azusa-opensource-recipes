#!/bin/sh
source ../../common/init.sh
inherit python
inherit cuda

get "https://github.com/TimDettmers/bitsandbytes/archive/refs/tags/${PV}.tar.gz" "${P}".tar.gz
acheck

cd "${S}" || exit

# bitsandbytes/libbitsandbytes_cuda122_nocublaslt.so

cmake -DCOMPUTE_BACKEND=cpu -DCMAKE_BUILD_TYPE=Release -S .
cmake --build . --config Release

for cuda_vers in 11.7 11.8 12.0 12.1 12.2 12.3 12.4; do
	# reset importpkg
	CPPFLAGS=""
	CPATH=""
	CMAKE_SYSTEM_INCLUDE_PATH=""
	C_INCLUDE_PATH=""
	LDFLAGS=""
	CMAKE_SYSTEM_LIBRARY_PATH=""
	RUSTFLAGS=""
	LIBRARY_PATH=""

	initcuda $cuda_vers

	echo "PATH = $PATH"

	build_capability="50;52;60;61;70;75;80;86;89;90"
	[[ "${cuda_vers}" == 11.7 ]] && build_capability=${build_capability%??????}
	[[ "${cuda_vers}" == 11.8 ]] && build_capability=${build_capability%???}

	for cublaslt in ON OFF; do
		rm -f CMakeCache.txt # avoid issues as we switch cuda versions
		cmake -DCOMPUTE_BACKEND=cuda -DCOMPUTE_CAPABILITY="$build_capability" -DNO_CUBLASLT=$cublaslt -DCMAKE_BUILD_TYPE=Release -S .
		cmake --build . --config Release
	done
done

pythonsetup
archive
