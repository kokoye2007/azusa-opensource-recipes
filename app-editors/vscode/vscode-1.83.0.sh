#!/bin/sh
source "../../common/init.sh"

vscodearch() {
	case $ARCH in
		amd64)
			echo x64
			;;
		arm)
			echo armhf
			;;
		arm64)
			echo arm64
			;;
		*)
			echo >&2 "Unsupported architecture $ARCH for vscode"
			exit 1
			;;
	esac
}

get https://update.code.visualstudio.com/"${PV}"/linux-$(vscodearch)/stable "${P}-${ARCH}.tar.gz"
acheck

cd "${S}" || exit

# Cleanup
rm -r ./resources/app/ThirdPartyNotices.txt || die

# Disable update server
sed -e "/updateUrl/d" -i ./resources/app/product.json || die

# add suid to chrome-sandbox
chmod 4711 chrome-sandbox

mkdir -p "${D}/pkg/main"
cd "${T}" || exit
mv "${S}" "${D}/pkg/main/${PKG}.core.${PVRF}"

finalize
