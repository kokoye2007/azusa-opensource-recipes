#!/bin/sh
source "../../common/init.sh"
inherit perl

get https://cpan.metacpan.org/authors/id/G/GF/GFRANKS/${P}.tar.gz
acheck

cd "${P}"

perlsetup
finalize
