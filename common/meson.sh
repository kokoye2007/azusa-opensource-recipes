# Meson build methods

domeson() {
	echo "Running meson..."
	if [ x"$MESON_ROOT" = x ]; then
		MESON_ROOT="${S}"
	fi

	meson "$MESON_ROOT" --prefix="/pkg/main/${PKG}.core.${PVRF}" -Dbuildtype=release "$@" || return $?

	echo "Building with ninja..."
	ninja || return $?
	DESTDIR="${D}" ninja install || return $?
}

