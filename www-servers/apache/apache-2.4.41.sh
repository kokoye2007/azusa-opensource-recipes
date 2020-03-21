#!/bin/sh
source "../../common/init.sh"

get https://archive.apache.org/dist/httpd/httpd-${PV}.tar.bz2

cd "${T}"

doconf --enable-authnz-fcgi --enable-mods-shared="all cgi" --enable-mpms-shared=all --enable-suexec=shared \
	--with-apr=/pkg/main/dev-libs.apr.core/bin/apr-1-config \
	--with-apr-util=/pkg/main/dev-libs.apr-util.core/bin/apu-1-config \
	--with-suexec-bin="/pkg/main/${PKG}.core.${PVRF}/bin/suexec" \
	--with-suexec-caller=apache --with-suexec-docroot=/srv/www --with-suexec-logfile=/var/log/httpd/suexec.log --with-suexec-uidmin=1000 --with-suexec-userdir=public_html

make
make install DESTDIR="${D}"

cd "${D}"

# keep etc in core for easy initial setup
mv etc "pkg/main/${PKG}.core.${PVRF}"

finalize
