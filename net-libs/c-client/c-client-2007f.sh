#!/bin/sh
source "../../common/init.sh"

get http://ftp.ntua.gr/pub/net/mail/imap/imap-${PV}.tar.gz

cd "imap-${PV}"

make lnp
make install DESTDIR="${D}"

finalize
