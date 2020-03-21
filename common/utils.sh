# various utils

make_wrapper() {
	# make in bin
	mkdir -pv "${D}/pkg/main/${PKG}.core.${PVR}/bin"
	cat >"${D}/pkg/main/${PKG}.core.${PVR}/bin/$1" <<EOF
#!/bin/sh
cd "$3" &&
exec $2 "\$@"
EOF
	chmod -v +x "${D}/pkg/main/${PKG}.core.${PVR}/bin/$1"
}
