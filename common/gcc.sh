# gcc

switchgcc() {
	local GCC_VERSION="$1"
	local GCC_PATH="$(realpath /pkg/main/sys-devel.gcc.core."$GCC_VERSION"/bin)"
	echo " * Switching to gcc-$GCC_VERSION at $GCC_PATH"
	export PATH="$GCC_PATH:$PATH"
	rm -f /usr/bin/gcc /usr/bin/g++
}
