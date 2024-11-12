#!/bin/sh
source "../../common/init.sh"
inherit perl

get https://cpan.metacpan.org/authors/id/C/CH/CHRISN/"${P}".tar.gz
acheck

cd "${P}" || exit
importpkg openssl zlib

perlsetup OPTIMIZE="$CPPFLAGS -O2" OPENSSL_PREFIX="/pkg/main/dev-libs.openssl.dev"
finalize
