#!/bin/sh
source "../../common/init.sh"
inherit perl

get https://cpan.metacpan.org/authors/id/M/MA/MARKF/"${P}".tar.gz
acheck

cd "${P}" || exit

perlsetup
finalize
