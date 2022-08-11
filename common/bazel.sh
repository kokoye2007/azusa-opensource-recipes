# Bazel utils

bazel_get() {
	# download bazel files in $WORKDIR/bazel-distdir
	mkdir "${T}/bazel-distdir"
	cd "${T}/bazel-distdir"
	for foo in $@; do
		if [ $(echo "$foo" | grep -c =) -eq 0 ]; then
			# save as is
			download "$foo"
		else
			url="$(echo "$foo" | cut -d= -f1)"
			fn="$(echo "$foo" | cut -d= -f2)"
			download "$url" "$fn"
			# rename back because bazel expects original filename, not the renamed fancy one (which we use so files look better on our archive)
			mv -v "$fn" "$(basename "$url")"
		fi
	done
	cd -
}

bazel_get_flags() {
	local i fs=()
	for i in ${CPPFLAGS}; do
		fs+=( "--conlyopt=${i}" )
		fs+=( "--cxxopt=${i}" )
	done
	for i in ${LDFLAGS}; do
		fs+=( "--linkopt=${i}" )
	done
	for i in ${CXXFLAGS}; do
		fs+=( "--cxxopt=${i}" )
	done
	for i in ${BUILD_CXXFLAGS}; do
		fs+=( "--host_cxxopt=${i}" )
	done
	echo "${fs[*]}"
}

abazel_setup_bazelrc() {
	if [[ -f "${T}/bazelrc" ]]; then
		return
	fi

	mkdir -p "${T}/bazel-cache"
	mkdir -p "${T}/bazel-distdir"

	cat > "${T}/bazelrc" <<-EOF
startup --batch

# dont strip HOME, portage sets a temp per-package dir
build --action_env HOME

# make bazel respect MAKEOPTS
build --jobs=${NPROC}
build --compilation_mode=opt --host_compilation_mode=opt

# FLAGS
build $(bazel_get_flags)

# Use standalone strategy to deactivate the bazel sandbox, since it
# conflicts with FEATURES=sandbox.
build --spawn_strategy=standalone --genrule_strategy=standalone
test --spawn_strategy=standalone --genrule_strategy=standalone

build --strip=never
build --verbose_failures --noshow_loading_progress
test --verbose_test_summary --verbose_failures --noshow_loading_progress

# make bazel only fetch distfiles from the cache
fetch --repository_cache="${T}/bazel-cache/" --distdir="${T}/bazel-distdir/"
build --repository_cache="${T}/bazel-cache/" --distdir="${T}/bazel-distdir/"

build --define=PREFIX=/pkg/main/${PKG}.core.${PVRF}
build --define=LIBDIR=/pkg/main/${PKG}.libs.${PVRF}/lib${LIB_SUFFIX}
build --define=INCLUDEDIR=/pkg/main/${PKG}.dev.${PVRF}/include
build --nodistinct_host_configuration
	EOF
}

abazel() {
	abazel_setup_bazelrc

	# --output_base="${output_base}"
	set -- bazel --bazelrc="${T}/bazelrc" ${@}
	echo "${*}"
	"${@}"
	return $?
}

