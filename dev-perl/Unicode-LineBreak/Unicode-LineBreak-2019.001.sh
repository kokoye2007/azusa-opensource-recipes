#!/bin/sh
source "../../common/init.sh"
inherit perl

get https://www.cpan.org/authors/id/N/NE/NEZUMI/"${P}".tar.gz
acheck

cd "${P}" || exit

perlsetup
finalize
