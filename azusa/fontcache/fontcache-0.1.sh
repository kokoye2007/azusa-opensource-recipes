#!/bin/sh
source "../../common/init.sh"

acheck

# let's generate /usr/share/fonts
mkdir -pv "${D}/pkg/main/${PKG}.data.symlinks.${PVRF}"

curl -s http://localhost:100/apkgdb/main?action=list \
	| grep '.*\..*\.fonts' \
	| grep -v ^app-text.texlive-texmf \
	| sed -Ee "s,(.*\..*\.fonts).*?\.${OS}\.${ARCH}$,\1," \
	| while read foo; do
	ln -snf "/pkg/main/$foo" "${D}/pkg/main/${PKG}.data.symlinks.${PVRF}"
done

ln -snfT "${D}/pkg/main/${PKG}.data.symlinks.${PVRF}" /usr/share/fonts # will replace existing symlink

# let's generate cache
rm -fr /var/cache/fontconfig
mkdir /var/cache/fontconfig

"/pkg/main/media-libs.fontconfig.core/bin/fc-cache" --system-only -v

# move it
mkdir -pv "${D}/pkg/main/${PKG}.data.cache.${PVRF}"
mv -vT /var/cache/fontconfig "${D}/pkg/main/${PKG}.data.cache.${PVRF}/fontconfig"

archive
