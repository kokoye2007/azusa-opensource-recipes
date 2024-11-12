#!/bin/sh
source "../../common/init.sh"
inherit perl

get https://cpan.metacpan.org/authors/id/G/GR/GRANTM/"${P}".tar.gz
acheck

cd "${P}" || exit

perlsetup
finalize
