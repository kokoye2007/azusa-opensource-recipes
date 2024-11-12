#!/bin/sh
source "../../common/init.sh"
inherit waf

importpkg sys-libs/libxcrypt

get http://samba.org/ftp/tdb/"${P}".tar.gz
acheck

dowaf

finalize
