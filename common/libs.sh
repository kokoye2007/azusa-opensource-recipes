# various methods for libs

preplib() {
	# prepare the place for libs, so they don't have to worry too much
	mkdir -pv "${D}/pkg/main/${PKG}.core.${PVRF}/"
	mkdir -pv "${D}/pkg/main/${PKG}.dev.${PVRF}/"
	mkdir -pv "${D}/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX"

	# symlinks
	ln -snfTv "../${PKG}.libs.${PVRF}/lib$LIB_SUFFIX" "${D}/pkg/main/${PKG}.core.${PVRF}/lib$LIB_SUFFIX"
	ln -snfTv "../${PKG}.libs.${PVRF}/lib$LIB_SUFFIX" "${D}/pkg/main/${PKG}.dev.${PVRF}/lib$LIB_SUFFIX"
	if [ "$MULTILIB" = yes ]; then
		# add lib symlinks
		ln -snfTv lib"$LIB_SUFFIX" "${D}/pkg/main/${PKG}.core.${PVRF}/lib"
		ln -snfTv lib"$LIB_SUFFIX" "${D}/pkg/main/${PKG}.libs.${PVRF}/lib"
		ln -snfTv lib"$LIB_SUFFIX" "${D}/pkg/main/${PKG}.dev.${PVRF}/lib"
	fi
}
