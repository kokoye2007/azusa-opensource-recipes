#!/bin/sh
source "../../common/init.sh"
inherit perl

get https://cpan.metacpan.org/authors/id/N/NE/NEILB/"${P}".tar.gz
acheck

cd "${P}" || exit

perlsetup
finalize
