#!/bin/sh
source "../../common/init.sh"

get https://github.com/ebassi/graphene/archive/refs/tags/"${PV}".tar.gz "${P}".tar.gz
acheck

cd "${T}" || exit

domeson -Dgobject_types=true -Dintrospection=enabled -Dgcc_vector=true -Dinstalled_tests=false

finalize
