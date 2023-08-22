#!/bin/sh
source "../../common/init.sh"

fetchgit https://github.com/google/usd_from_gltf.git 6d288cce8b68744494a226574ae1d7ba6a9c46eb
acheck

cd "${S}"

apatch "$FILESDIR/usd_from_gltf-json-lib.patch"

cd "${T}"

docmake

finalize
