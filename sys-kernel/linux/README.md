# Configuring kernel (tests)

Run:

	echo 'include /pkg/main/sys-kernel.linux.src/Makefile' >Makefile

Then you can run `make menuconfig` or any other command typically used.

# Crossdev targets

We use golang's GOARCH values to specify targets:

* arm64: aarch64-unknown-linux-gnu
* 386: i686-pc-linux-gnu
* amd64: x86_64-pc-linux-gnu
