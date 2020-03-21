#!/bin/sh
source "../../common/init.sh"
inherit waf

get https://download.samba.org/pub/samba/stable/${P}.tar.gz
acheck

cd "${S}"

importpkg app-crypt/gpgme libbsd dev-libs/icu app-arch/libarchive sys-apps/acl sys-libs/pam sys-libs/libunwind net-print/cups zlib sys-libs/ldb net-nds/openldap dev-libs/libgpg-error sys-libs/ncurses

export LDFLAGS="${LDFLAGS}"

CONFIGURE=(
	--enable-fhs
	--sysconfdir="/etc"
	--localstatedir="/var"
	--with-modulesdir="/pkg/main/${PKG}.mod.${PVRF}/samba"
	--with-piddir="/run/${PN}"

	# rpath disable needed?
	--disable-rpath
	--disable-rpath-install

	--nopyc
	--nopyo

	--with-acl-support
	--with-dnsupdate
	--with-ads
	--with-ldap
	#--with-cephfs
	--with-cluster-support
	--enable-cups
	# --with-dmapi # for xfs?
	--with-gpgme
	--enable-iprint
	--with-pam
	--with-quotas
	--with-syslog
	--with-winbind
	--enable-avahi
	--with-shared-modules="idmap_rid,idmap_tdb2,idmap_ad"

	# to remove once we have heimdal
	--bundled-libraries="heimbase,heimntlm,hdb,kdc,krb5,wind,gssapi,hcrypto,hx509,roken,asn1,com_err,NONE"
	# --with-system-mitkrb5
	--builtin-libraries=NONE
)

dowaf "${CONFIGURE[@]}"

finalize
