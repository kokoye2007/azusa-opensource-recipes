# Meson build methods

domeson() {
	echo "Running meson..."
	if [ "$MESON_ROOT" = "" ]; then
		MESON_ROOT="${S}"
	fi

	meson setup "$MESON_ROOT" --prefix="/pkg/main/${PKG}.core.${PVRF}" -Dbuildtype=release "$@" || return $?

	echo "Building with ninja..."
	ninja || return $?
	DESTDIR="${D}" ninja install || return $?
}

