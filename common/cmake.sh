# Cmake utils

docmake() {
	echo "Running cmake..."
	if [ x"$CMAKE_ROOT" = x ]; then
		CMAKE_ROOT="${S}"
	fi

	# for kde's extra-cmake-modules
	export ECM_DIR=/pkg/main/kde-frameworks.extra-cmake-modules.core/share/ECM/cmake

	set -- "$CMAKE_ROOT" \
		-DCMAKE_INSTALL_PREFIX="/pkg/main/${PKG}.core.${PVRF}" \
		-DCMAKE_BUILD_TYPE=Release \
		-DBUILD_SHARED_LIBS=ON \
		-DCMAKE_SYSTEM_INCLUDE_PATH="${CMAKE_SYSTEM_INCLUDE_PATH}" \
		-DCMAKE_SYSTEM_LIBRARY_PATH="${CMAKE_SYSTEM_LIBRARY_PATH}" \
		-DCMAKE_C_FLAGS="${CPPFLAGS} -O2" \
		-DCMAKE_CXX_FLAGS="${CPPFLAGS} -O2" \
		"$@"

	echo "Running: cmake $@"
	cmake "$@" || return $?
}
