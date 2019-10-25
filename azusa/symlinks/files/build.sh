#!/bin/sh
set -e

MULTILIB=yes

cd $1
mkdir -p bin sbin info share/gir-1.0 include etc etc/ssl include full/include
ln -snf /pkg/main/app-misc.ca-certificates/etc/ssl/certs etc/ssl/certs

if [ $MULTILIB = yes ]; then
	mkdir -p lib32 lib64 full/lib32 full/lib64
	ln -s lib64 lib
	ln -s lib64 full/lib
	LIBS="lib64 lib32 lib"
	LIB=lib64

	#ln -s `realpath /pkg/main/sys-libs.glibc.libs`/lib64/ld-linux-x86-64.so.2 lib64
	cp -rsfT `realpath /pkg/main/sys-libs.glibc.libs/lib64` lib64
else
	LIBS=lib
	LIB=lib
	mkdir -p lib full/lib
fi
mkdir -p "$LIB/cmake" "$LIB/pkgconfig" "$LIB/modules"
ln -snf "$LIB/cmake" cmake
ln -snf "$LIB/pkgconfig" pkgconfig

# build includes
echo "Building include folder..."
for foo in sys-libs/glibc sys-libs/libcxx sys-kernel/linux; do
	# use realpath to resolve path to full path with version
	cp -rsfT $(realpath /pkg/main/${foo/\//.}.dev/include) ./include
done

for pn in $(curl -s http://localhost:100/apkgdb/main?action=list | grep -v busybox | grep -v symlinks); do
	echo -ne "\rScanning: $pn\033[K"
	p=/pkg/main/${pn}
	t=`echo "$pn" | cut -d. -f3`

	if [ ! -d "${p}" ]; then
		# not available?
		continue
	fi

	case $pn in
		sys-kernel.linux.modules.*)
			# link to lib
			ln -snf "${p}/lib/modules"/* "$LIB/modules"
			;;
	esac

	case $t in
		core)
			for foo in bin sbin info share/gir-1.0; do
				if [ -d "${p}/${foo}" ]; then
					cp -rsfT "${p}/${foo}" "${foo}"
				fi
			done
			;;
		dev)
			for foo in cmake pkgconfig; do
				if [ -d "${p}/${foo}" ]; then
					cp -rsfT "${p}/${foo}" "$LIB/${foo}"
				fi
			done
			for foo in bin sbin; do
				if [ -d "${p}/${foo}" -a ! -L "${p}/${foo}" ]; then
					cp -rsfT "${p}/${foo}" "${foo}"
				fi
			done

			# generate full/include
			if [ -d "${p}/include" ]; then
				cp -rsfT "${p}/include" "full/include"
			fi
			;;
		mod)
			for foo in cmake pkgconfig; do
				if [ -d "${p}/${foo}" ]; then
					cp -rsfT "${p}/${foo}" "$LIB/${foo}"
				fi
			done
			;;
		doc)
			for foo in man info; do
				if [ -d "${p}/$foo" ]; then
					cp -rsfT "${p}/$foo" $foo
				fi
			done
			;;
		libs)
			for foo in $LIBS; do
				if [ -d "${p}/$foo" -a ! -L "${p}/$foo" ]; then
					echo "${p}/$foo" >>etc/ld.so.conf.tmp
					# generate symlinks for full/lib64
					cp >/dev/null 2>&1 -rsfT "${p}/$foo" full/$foo/ || true
				fi
			done
			;;
		*)
			echo -e "\rRejected package: $pn\033[K"
			;;
	esac
	# TODO: fonts, sgml
done
echo

realpath /pkg/main/sys-libs.glibc.libs/$LIB >>etc/ld.so.conf.tmp
tac etc/ld.so.conf.tmp >etc/ld.so.conf
rm etc/ld.so.conf.tmp

echo "Generating ld.so.cache..."
# reorg ld.so.conf the other way around
/pkg/main/sys-libs.glibc.core/sbin/ldconfig -X -C etc/ld.so.cache -f etc/ld.so.conf 
