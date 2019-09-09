#!/bin/sh
source "../../common/init.sh"

mkdir -p "${D}/pkg/main/${PKG}.${PVR}"
cd "${D}/pkg/main/${PKG}.${PVR}"
mkdir "certificates"

# copy certificates from local gentoo (should come from nss)
rsync -av --progress "/usr/share/ca-certificates/" "./ca-certificates/"
mkdir -p etc/ssl/certs
cp /etc/ca-certificates.conf etc

# call update-ca-certificates
/usr/sbin/update-ca-certificates --verbose --certsconf /etc/ca-certificates.conf --localcertsdir /ca-certificates --etccertsdir /etc/ssl/certs --root "`pwd`/"

finalize
