#!/bin/sh
source "../../common/init.sh"
inherit perl

get https://www.cpan.org/authors/id/O/OA/OALDERS/"${P}".tar.gz
acheck

cd "${P}" || exit
patch -p1 -i "$FILESDIR/${P}-system_certs-1.patch"

perlsetup
finalize
