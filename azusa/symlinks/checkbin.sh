#!/bin/sh

# check binaries
checkbin() {
	if [ ! -f /pkg/main/dev-util.patchelf.core/bin/patchelf ]; then
		echo "FIXELF ERROR: patchelf not found, skipping check"
		return
	fi
	# locate all binaries that have .interp pointing to /lib64/ld-linux-x86-64.so.2
	# and use patchelf to fix it
	# readelf -p .interp /bin/bash | grep ld-linux | awk '{ print $3 }'
	# file /bin/bash
	# /pkg/main/dev-util.patchelf.core/bin/patchelf --print-interpreter /bin/bash
	# /pkg/main/dev-util.patchelf.core/bin/patchelf --set-interpreter /pkg/main/sys-libs.glibc.libs/lib64/ld-linux-x86-64.so.2
	for fn in /pkg/main/azusa.symlinks.core/bin/* /pkg/main/azusa.symlinks.core/sbin/*; do
		fn="$(realpath "$fn")"
		local ft
		ft="$(file -b "$fn")"
		case $ft in
			ELF*dynamically*interpreter*)
				cur="$(/pkg/main/dev-util.patchelf.core/bin/patchelf --print-interpreter "${fn}")"
				case $cur in
					/lib64/ld-linux-x86-64.so.2)
						echo "Needs rebuild: $fn"
						;;
					/lib/ld-linux.so.2)
						echo "Needs rebuild: $fn"
						;;
					/lib/ld-linux-aarch64.so.1)
						echo "Needs rebuild: $fn"
						;;
				esac
				;;
		esac
	done
}
checkbin
