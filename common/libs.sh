# various methods for libs

preplib() {
	# prepare the place for libs, so they don't have to worry too much
	mkdir -pv "${D}/pkg/main/${PKG}.core.${PVR}/"
	mkdir -pv "${D}/pkg/main/${PKG}.dev.${PVR}/"
	mkdir -pv "${D}/pkg/main/${PKG}.libs.${PVR}/lib$LIB_SUFFIX"

	# symlinks
	ln -snfTv "../${PKG}.libs.${PVR}/lib$LIB_SUFFIX" "${D}/pkg/main/${PKG}.core.${PVR}/lib$LIB_SUFFIX"
	ln -snfTv "../${PKG}.libs.${PVR}/lib$LIB_SUFFIX" "${D}/pkg/main/${PKG}.dev.${PVR}/lib$LIB_SUFFIX"
	if [ $MULTILIB = yes ]; then
		# add lib symlinks
		ln -snfTv lib$LIB_SUFFIX "${D}/pkg/main/${PKG}.core.${PVR}/lib"
		ln -snfTv lib$LIB_SUFFIX "${D}/pkg/main/${PKG}.libs.${PVR}/lib"
		ln -snfTv lib$LIB_SUFFIX "${D}/pkg/main/${PKG}.dev.${PVR}/lib"
	fi
}
