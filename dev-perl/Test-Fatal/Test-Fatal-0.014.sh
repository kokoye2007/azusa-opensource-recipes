#!/bin/sh
source "../../common/init.sh"
inherit perl

get https://cpan.metacpan.org/authors/id/R/RJ/RJBS/"${P}".tar.gz
acheck

cd "${P}" || exit

perlsetup
finalize
