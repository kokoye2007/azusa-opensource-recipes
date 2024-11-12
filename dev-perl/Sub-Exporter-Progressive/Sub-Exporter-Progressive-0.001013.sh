#!/bin/sh
source "../../common/init.sh"
inherit perl

get https://cpan.metacpan.org/authors/id/F/FR/FREW/"${P}".tar.gz
acheck

cd "${P}" || exit

perlsetup
finalize
