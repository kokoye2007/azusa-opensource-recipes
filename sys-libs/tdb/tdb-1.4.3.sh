#!/bin/sh
source "../../common/init.sh"
inherit waf

get http://samba.org/ftp/tdb/${P}.tar.gz
acheck

dowaf

finalize
