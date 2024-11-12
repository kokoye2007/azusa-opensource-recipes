#!/bin/sh
source "../../common/init.sh"

ver_cut() {
	echo "$PV" | cut -d. -f"$1"
}

DEB_VER=$(ver_cut 1)
NSS_VER=$(ver_cut 2-)
RTM_NAME="NSS_${NSS_VER//./_}_RTM"

get https://ftp.jp.debian.org/debian/pool/main/c/"${PN}"/"${PN}"_"${DEB_VER}"${NMU_PR:++nmu}"${NMU_PR}".tar.xz
get https://archive.mozilla.org/pub/security/nss/releases/"${RTM_NAME}"/src/nss-"${NSS_VER}".tar.gz
get https://dev.gentoo.org/~whissi/dist/ca-certificates/nss-cacert-class1-class3-r2.patch
acheck

echo "this needs fixing"
exit 1

mkdir -p "${D}/pkg/main/${PKG}.core.${PVRF}"
cd "${D}/pkg/main/${PKG}.core.${PVRF}" || exit
mkdir "certificates"

# copy certificates from local gentoo (should come from nss)
rsync -av --progress "/usr/share/ca-certificates/" "./ca-certificates/"
mkdir -p etc/ssl/certs
cp /etc/ca-certificates.conf etc

# call update-ca-certificates
/usr/sbin/update-ca-certificates --verbose --certsconf /etc/ca-certificates.conf --localcertsdir /ca-certificates --etccertsdir /etc/ssl/certs --root "$(pwd)/"

finalize
