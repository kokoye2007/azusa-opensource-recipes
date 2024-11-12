#!/bin/sh
source "../../common/init.sh"
inherit waf

importpkg dev-db/lmdb sys-libs/libxcrypt

get https://www.samba.org/ftp/"${PN}"/"${P}".tar.gz
acheck

dowaf

finalize
