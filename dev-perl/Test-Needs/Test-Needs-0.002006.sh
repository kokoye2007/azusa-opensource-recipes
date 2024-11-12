#!/bin/sh
source "../../common/init.sh"
inherit perl

get https://cpan.metacpan.org/authors/id/H/HA/HAARG/"${P}".tar.gz
acheck

cd "${P}" || exit

perlsetup
finalize
