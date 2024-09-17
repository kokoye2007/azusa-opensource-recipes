#!/bin/sh
source "../../common/init.sh"
inherit bazel

get https://github.com/prysmaticlabs/prysm/archive/refs/tags/v${PV}.tar.gz ${P}.tar.gz
envcheck
# do not use acheck so we keep networking

cd "${S}"

abazel build //cmd/beacon-chain:beacon-chain --config=release
abazel build //cmd/validator:validator --config=release

mkdir -p "${D}/pkg/main/${PKG}.core.${PVRF}/bin"
mv -v bazel-bin/cmd/beacon-chain/beacon-chain_/beacon-chain "${D}/pkg/main/${PKG}.core.${PVRF}/bin"
mv -v bazel-bin/cmd/validator/validator_/validator "${D}/pkg/main/${PKG}.core.${PVRF}/bin"

finalize
