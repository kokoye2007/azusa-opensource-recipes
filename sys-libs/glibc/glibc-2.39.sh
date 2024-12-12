#!/bin/sh
source "../../common/init.sh"

# fetch xz, compile, build
get http://ftp.jaist.ac.jp/pub/GNU/libc/${P}.tar.xz
acheck

cd "${T}"

# sysconfdir defines where ld.so.cache is found:
# ./sysdeps/generic/dl-cache.h:38:# define LD_SO_CACHE SYSCONFDIR "/ld.so.cache"

CONFIGURE=(
	--host="$CHOST"
	--sysconfdir="/pkg/main/azusa.ldso.data.${OS}.${ARCH}/etc"
	--disable-werror
	--enable-kernel=4.14
	--enable-stack-protector=strong
	--enable-stackguard-randomization
	--with-headers=/pkg/main/sys-kernel.linux.dev.${OS}.${ARCH}/include
	--without-cvs
	--disable-werror
	--enable-bind-now
	--enable-fortify-source
	--with-bugurl=https://github.com/AzusaOS/azusa-opensource-recipes/issues
	--with-pkgversion="Azusa glibc ${PVR}"
	--disable-crypt
	--enable-multi-arch
#	--enable-systemtap
	--enable-nscd
	--disable-timezone-tools
	libc_cv_slibdir=/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX
)
# ac_cv_path_PERL=/pkg/main/dev-lang.perl.core/bin/perl
# libc_cv_complocaledir=...?

if [ "$ARCH" == "amd64" ]; then
	CONFIGURE+=(--enable-cet)
fi

if [ "$ARCH" == "386" ]; then
	if [ "$(uname -m)" = "x86_64" ]; then
		# force 32bits gcc
		CONFIGURE+=(CC="gcc -m32" CXX="g++ -m32")
	fi
fi

# configure & build
doconf "${CONFIGURE[@]}" || /bin/bash -i

make -j"$NPROC"
make install DESTDIR="${D}"

# compatibility libraries for the NIS/NIS+ support, do not need .so or .a, only .so.X (gentoo)
echo "Deleting libnsl.(a|so) ..."
find "${D}" -name "libnsl.a" -delete
find "${D}" -name "libnsl.so" -delete

# With devpts under Linux mounted properly, we do not need the pt_chown suid bit (gentoo)
echo "Removing suid bit on pt_chown ..."
find "${D}" -name pt_chown -exec chmod -s {} +

# generate share/i18n/SUPPORTED (Debian-style locale updating)
echo "Generating locales ..."
mkdir -pv "${D}/pkg/main/${PKG}.core.${PVRF}/share/i18n"
sed -e "/^#/d" -e "/SUPPORTED-LOCALES=/d" -e "s: \\\\::g" -e "s:/: :g" "${S}"/localedata/SUPPORTED > "${D}/pkg/main/${PKG}.core.${PVRF}/share/i18n/SUPPORTED"

locale_list=`echo "C.UTF-8 UTF-8"; cat "${D}/pkg/main/${PKG}.core.${PVRF}/share/i18n/SUPPORTED"`

mkdir -p "${D}/pkg/main/${PKG}.data.locale.${PVRF}"

# we create this link temporarily this way so we can grab the generated files in the right location
ln -snfT "${D}/pkg/main/${PKG}.data.locale.${PVRF}" "${D}/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX/locale"

# install "C" locale
cp -vT "${FILESDIR}/C-locale" "${D}/pkg/main/${PKG}.core.${PVRF}/share/i18n/locales/C"

localedef() {
	# run newly installed localedef
	# this trick allows running it against the new glibc even before new glibc is installed
	local NEWLIBDIR="${D}/pkg/main/${PKG}.libs.${PVRF}/lib${LIB_SUFFIX}"
	#LD_LIBRARY_PATH="$NEWLIBDIR" "${NEWLIBDIR}/ld-linux-x86-64.so.2" "${D}/pkg/main/${PKG}.core.${PVRF}/bin/localedef" "$@"
	LD_LIBRARY_PATH="$NEWLIBDIR" "${D}/pkg/main/${PKG}.core.${PVRF}/bin/localedef" "$@" || /bin/bash -i
}

if [ -d "/pkg/main/${PKG}.core.${PVRF}" ]; then
# generate locales
mkdir -p "${D}/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX/locale"
OIFS="$IFS"
IFS=$'\n'
for foo in $locale_list; do
	locale=`echo "$foo" | cut -f1 -d' '`
	charset=`echo "$foo" | cut -f2 -d' '`
	locale_short=${locale%%.*}
	echo " * Generating locale $locale_short ($charset)"
	localedef -c --no-archive -i "${D}/pkg/main/${PKG}.core.${PVRF}/share/i18n/locales/$locale_short" -f "$charset" -A "${D}/pkg/main/${PKG}.core.${PVRF}/share/locale/locale.alias" --prefix "${D}" "${locale}"
done
IFS="$OIFS"

# generate locale archive
echo "Generating locale archive..."
for foo in "${D}/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX/locale"/*/; do
	localedef --add-to-archive "${foo%/}" --replace --prefix "${D}" && rm -fr "${foo%/}"
done

# fix link to point to symlinks, this way we can generate locale-archive with other i18n paths
echo "Fixing locale symlink..."
ln -snfT "/pkg/main/${PKG}.data.locale.${PVRF}" "${D}/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX/locale"

else
	echo "Cannot build locales without installation done once first"
fi

# make dev a sysroot for gcc
ln -snfTv "/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX" "${D}/pkg/main/${PKG}.dev.${PVRF}/lib$LIB_SUFFIX"
if [ x"$LIB_SUFFIX" != x ]; then
	ln -snfTv "lib$LIB_SUFFIX" "${D}/pkg/main/${PKG}.dev.${PVRF}/lib"
fi
ln -snfTv . "${D}/pkg/main/${PKG}.dev.${PVRF}/usr"

# linux includes
for foo in /pkg/main/sys-kernel.linux.dev/include/*; do
	BASE=`basename "$foo"`
	if [ -d "${D}/pkg/main/${PKG}.dev.${PVRF}/include/$BASE" ]; then
		# already a dir there, need to do a cp operation
		cp -rsfT "$foo" "${D}/pkg/main/${PKG}.dev.${PVRF}/include/$BASE"
	else
		ln -snfvT "$foo" "${D}/pkg/main/${PKG}.dev.${PVRF}/include/$BASE"
	fi
done

# c++ includes from gcc + libs
ln -snfv /pkg/main/sys-devel.gcc.dev/include/c++ "${D}/pkg/main/${PKG}.dev.${PVRF}/include/"
ln -snfvT /pkg/main/sys-devel.gcc.libs/lib64/libstdc++.so "${D}/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX/libstdc++.so"

# add link to ld.so.conf and ld.so.cache since binutils will be looking for it here
mkdir "${D}/pkg/main/${PKG}.dev.${PVRF}/etc"
ln -snf /pkg/main/azusa.ldso.data.${OS}.${ARCH}/etc/ld.so.* "${D}/pkg/main/${PKG}.dev.${PVRF}/etc/"

# move etc/rpc
mv -v "${D}/pkg/main/azusa.ldso.data.${OS}.${ARCH}/etc/rpc" "${D}/pkg/main/${PKG}.dev.${PVRF}/etc/"
rm -v "${D}/pkg/main/azusa.ldso.data.${OS}.${ARCH}/etc/ld.so.cache" || true
rmdir -v "${D}/pkg/main/azusa.ldso.data.${OS}.${ARCH}/etc" || /bin/bash -i
rmdir -v "${D}/pkg/main/azusa.ldso.data.${OS}.${ARCH}"

# add a link to /pkg in sysroot, because binutils will always prefix sysroot to paths found in ld.so.conf
ln -snfT /pkg "${D}/pkg/main/${PKG}.dev.${PVRF}/pkg"

# symlink share/zoneinfo to /pkg/main/sys-libs.timezone-data.core
ln -snfT /pkg/main/sys-libs.timezone-data.core "${D}/pkg/main/${PKG}.core.${PVRF}/share/zoneinfo"

# this is to make clang happy
mkdir -p "${D}/pkg/main/${PKG}.dev.${PVRF}/etc/env.d"
ln -sT /pkg/main/sys-devel.gcc-config.core/gcc-config "${D}/pkg/main/${PKG}.dev.${PVRF}/etc/env.d/gcc"

if [ "$ARCH" == "amd64" ]; then
	# if building on amd64, add symlinks to 386 versions of stubs & libnames
	ln -snfv "/pkg/main/${PKG}.dev.${PVR}.${OS}.386/usr/include/gnu"/{lib-names,stubs}-32.h "${D}/pkg/main/${PKG}.dev.${PVRF}/usr/include/gnu/"
fi

fixelf
archive
