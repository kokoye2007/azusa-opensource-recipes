#!/bin/sh
source "../../common/init.sh"
inherit perl

importpkg dev-libs/icu
export INC="$CPPFLAGS"

get https://cpan.metacpan.org/authors/id/S/SH/SHLOMIF/"${P}".tar.gz
acheck

cd "${P}" || exit

perlsetup
finalize
