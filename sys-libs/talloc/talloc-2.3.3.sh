#!/bin/sh
source "../../common/init.sh"
inherit waf

importpkg sys-libs/libxcrypt

get https://www.samba.org/ftp/${PN}/${P}.tar.gz
acheck

dowaf

finalize
