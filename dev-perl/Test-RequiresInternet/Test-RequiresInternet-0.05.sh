#!/bin/sh
source "../../common/init.sh"
inherit perl

get https://cpan.metacpan.org/authors/id/M/MA/MALLEN/${P}.tar.gz
acheck

cd "${P}"

perlsetup
finalize
