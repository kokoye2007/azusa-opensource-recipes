#!/bin/sh
source "../../common/init.sh"
inherit perl

get https://cpan.metacpan.org/authors/id/H/HM/HMBRAND/"${P}".tgz
acheck

cd "${P}" || exit

perlsetup
finalize
