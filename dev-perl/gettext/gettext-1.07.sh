#!/bin/sh
source "../../common/init.sh"
inherit perl

get https://cpan.metacpan.org/authors/id/P/PV/PVANDRY/"${P}".tar.gz
acheck

cd "${S}" || exit

perlsetup
finalize
