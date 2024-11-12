#!/bin/sh
source "../../common/init.sh"
inherit perl

get https://cpan.metacpan.org/authors/id/T/TO/TODDR/"${P}".tar.gz
acheck

cd "${P}" || exit

perlsetup EXPATLIBPATH="/pkg/main/dev-libs.expat.libs/lib$LIB_SUFFIX" EXPATINCPATH="/pkg/main/dev-libs.expat.dev/include"
finalize
