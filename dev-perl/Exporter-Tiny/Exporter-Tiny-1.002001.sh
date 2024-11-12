#!/bin/sh
source "../../common/init.sh"
inherit perl

get https://cpan.metacpan.org/authors/id/T/TO/TOBYINK/"${P}".tar.gz
acheck

cd "${P}" || exit

perlsetup
finalize
