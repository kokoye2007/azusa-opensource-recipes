#!/bin/bash

# go to root dir
cd "$(dirname "$0")/.." || exit

source "common/env.sh"

chroot "$tmp_dir" /bin/bash --login "$@"
