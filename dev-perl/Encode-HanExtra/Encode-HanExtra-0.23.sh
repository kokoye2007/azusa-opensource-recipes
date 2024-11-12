#!/bin/sh
source "../../common/init.sh"
inherit perl

get https://www.cpan.org/authors/id/A/AU/AUDREYT/"${P}".tar.gz
acheck

cd "${P}" || exit

export PERL_USE_UNSAFE_INC=1

perlsetup
finalize
