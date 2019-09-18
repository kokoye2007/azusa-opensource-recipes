#!/bin/bash
set -e

# go to root dir
cd "$(dirname $0)/.."

# Compile a given package ($1) within a jail
PKG="$1"
PKG_DIR=`dirname "$PKG"`
PKG_SCRIPT=`basename "$PKG"`

echo "Preparing to build $PKG"

source "common/env.sh"

echo "Fetching azusa-opensource-recipes ..."

chroot "$tmp_dir" /bin/bash -c "cd /root; git clone -q https://github.com/AzusaOS/azusa-opensource-recipes.git"

echo "Build..."

chroot "$tmp_dir" /bin/bash -c "cd /root/azusa-opensource-recipes/${PKG_DIR}; ./${PKG_SCRIPT}"

mkdir /tmp/apkg || true
mv -v "$tmp_dir/tmp/apkg"/* /tmp/apkg

# fix rights on /tmp/apkg to make sure user can upload
chown 1000 -R /tmp/apkg
