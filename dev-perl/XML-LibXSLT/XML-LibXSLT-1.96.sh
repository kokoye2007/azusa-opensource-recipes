#!/bin/sh
source "../../common/init.sh"
inherit perl

get https://www.cpan.org/authors/id/S/SH/SHLOMIF/"${P}".tar.gz
acheck

cd "${P}" || exit

importpkg dev-libs/icu libxslt libxml-2.0 zlib

perlsetup INC="$CPPFLAGS"
finalize
