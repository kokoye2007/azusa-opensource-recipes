#!/bin/sh
source "../../common/init.sh"
inherit perl

get https://cpan.metacpan.org/authors/id/C/CJ/CJM/"${P}".tar.gz
acheck

cd "${P}" || exit

perlsetup
finalize
