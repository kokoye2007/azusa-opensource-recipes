#!/bin/sh
source "../../common/init.sh"
inherit perl

get https://cpan.metacpan.org/authors/id/L/LE/LEONT/${P}.tar.gz
acheck

cd "${P}"

perlsetup
finalize
