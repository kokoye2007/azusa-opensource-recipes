#!/bin/sh
source "../../common/init.sh"
inherit perl

get https://cpan.metacpan.org/authors/id/C/CO/CORION/"${P}".tar.gz
acheck

cd "${P}" || exit

perlsetup
finalize
