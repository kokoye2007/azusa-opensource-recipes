#!/bin/sh
source "../../common/init.sh"
inherit waf

get https://www.samba.org/ftp/${PN}/${P}.tar.gz
acheck

dowaf

finalize
