#!/bin/sh
source "../../common/init.sh"

TZ=`date +%Y%m%d`
PVR="${PV}.${TZ}.${OS}.${ARCH}"

mkdir -p "${D}/pkg/main/${PKG}.core.${PVR}"
cd "${D}/pkg/main/${PKG}.core.${PVR}"

# install makeroot in "azusa"
mkdir "azusa"
cp "$FILESDIR/makeroot.sh" azusa/

mkdir -p bin sbin info share/gir-1.0 share/aclocal etc etc/ssl etc/xml full/include
ln -snf /pkg/main/app-misc.ca-certificates/etc/ssl/certs etc/ssl/certs

if [ $MULTILIB = yes ]; then
	mkdir -p lib32 lib64 full/lib32 full/lib64
	ln -s lib64 lib
	ln -s lib64 full/lib
	LIBS="lib64 lib32 lib"
	LIB=lib64

	#ln -s `realpath /pkg/main/sys-libs.glibc.libs`/lib64/ld-linux-x86-64.so.2 lib64
	#cp -rsfT `realpath /pkg/main/sys-libs.glibc.libs/lib64` lib64
	cp -rsf /pkg/main/sys-libs.glibc.libs/lib64/ld-linux* lib64
else
	LIBS=lib
	LIB=lib
	mkdir -p lib full/lib

	#cp -rsfT `realpath /pkg/main/sys-libs.glibc.libs/lib` lib
	cp -rsf /pkg/main/sys-libs.glibc.libs/lib/ld-linux* lib
fi
mkdir -p "$LIB/cmake" "$LIB/pkgconfig" "$LIB/modules"
ln -snf "$LIB/cmake" cmake
ln -snf "$LIB/pkgconfig" pkgconfig
ln -snf . usr
xmlcatalog --noout --create etc/xml/catalog

for pn in $(curl -s http://localhost:100/apkgdb/main?action=list | grep -v busybox | grep -v symlinks); do
	echo -ne "\rScanning: $pn\033[K"
	p=/pkg/main/${pn}
	t=`echo "$pn" | cut -d. -f3`

	if [ "$t" == "src" ] || [ "$t" == "data" ] || [ "$t" == "i18n" ]; then
		# do not even do access to sources, data or i18n
		continue
	fi

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
			for foo in bin sbin share/gir-1.0 share/aclocal; do
				if [ -d "${p}/${foo}" -a ! -L "${p}/${foo}" ]; then
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
				cp 2>/dev/null -rsfT "${p}/include" "full/include" || true
			fi
			;;
		mod)
			for foo in cmake pkgconfig; do
				if [ -d "${p}/${foo}" ]; then
					cp -rsfT "${p}/${foo}" "$LIB/${foo}"
				fi
			done
			;;
		modules)
			# sys-kernel.linux.modules
			;;
		data)
			# private data, do not touch
			;;
		doc)
			for foo in man info; do
				if [ -d "${p}/$foo" -a ! -L "${p}/$foo" ]; then
					cp -rsfT "${p}/$foo" $foo
				fi
			done
			;;
		libs)
			LACNT=`find ${p} -name '*.la' | wc -l`
			if [ $LACNT -gt 0 ]; then
				echo -e "\rNeeds rebuild (.la files found): $pn\033[K"
			fi
			for foo in $LIBS; do
				if [ -d "${p}/$foo" -a ! -L "${p}/$foo" ]; then
					echo "${p}/$foo" >>etc/ld.so.conf.tmp
					# generate symlinks for full/lib64
					cp >/dev/null 2>&1 -rsfT "${p}/$foo" full/$foo/ || true
				fi
			done
			;;
		sgml)
			# locate authority files, add to etc/xml/catalog
			find "${p}" -name '*.xmlcatalog' | while read foo; do
				replace="file://${foo%.xmlcatalog}" # strip .xmlcatalog
				replace="${replace%/}" # optionally strip /
				cat "$foo" | while read bar; do
					typ=`echo "$bar" | cut -d' ' -f1`
					orig=`echo "$bar" | cut -d' ' -f2-`
					xmlcatalog --noout --add "$typ" "$orig" "$replace" etc/xml/catalog
				done
			done
			;;
		*)
			echo -e "\rRejected package: $pn\033[K"
			;;
	esac
	# TODO: fonts
done
echo

# include all of gcc's stupid libs
for foo in `realpath /pkg/main/sys-devel.gcc.libs`/*; do
	echo "$foo" >>etc/ld.so.conf.tmp
done
# reverse order in ld.so.conf so newer versions are on top and taken in priority
tac etc/ld.so.conf.tmp >etc/ld.so.conf
rm etc/ld.so.conf.tmp

echo "Generating ld.so.cache..."
/pkg/main/sys-libs.glibc.core/sbin/ldconfig -X -C etc/ld.so.cache -f etc/ld.so.conf 

archive
