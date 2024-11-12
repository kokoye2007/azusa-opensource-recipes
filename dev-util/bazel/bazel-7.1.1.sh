#!/bin/sh
source "../../common/init.sh"

get https://github.com/bazelbuild/bazel/releases/download/"${PV}"/"${P}"-dist.zip
acheck

apatch "$FILESDIR/bazel-5.0.0-allow-pkg-sys-includes-azusa.patch"

export JAVA_HOME="/pkg/main/dev-java.openjdk.core.linux.${ARCH}" # so keepwork works
export EXTRA_BAZEL_ARGS="--jobs=$(nproc) --java_runtime_version=local_jdk --tool_java_runtime_version=local_jdk"

VERBOSE=yes ./compile.sh

#./scripts/generate_bash_completion.sh --bazel=output/bazel --prepend=scripts/bazel-complete-header.bash --prepend=scripts/bazel-complete-template.bash

mkdir -p "${S}/pkg/main/${PKG}.core.${PVRF}/bin"
install -v -m0755 -D -T output/bazel "${D}/pkg/main/${PKG}.core.${PVRF}/bin/bazel"
# newbashcomp bazel-complete.bash
# zsh?

# tools?

# we do not use finalize because fixelf corrupts bazel exe (which is actually a zip file concatenated with the exe)
archive
