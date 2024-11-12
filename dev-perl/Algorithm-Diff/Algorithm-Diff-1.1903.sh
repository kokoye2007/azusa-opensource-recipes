#!/bin/sh
source "../../common/init.sh"
inherit perl

get https://cpan.metacpan.org/authors/id/T/TY/TYEMQ/"${P}".tar.gz
acheck

cd "${P}" || exit

perlsetup
finalize
