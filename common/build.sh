#!/bin/bash
set -e

# go to root dir
cd "$(dirname $0)/.."
AZUSA_RECIPES_ROOT=`pwd`

# Compile a given package ($1) within a jail
PKG="$1"

if [ -f "$PKG" ]; then
	PKG_DIR=`dirname "$PKG"`
	PKG_SCRIPT=`basename "$PKG"`
elif [ -d "$PKG" ]; then
	# try to locate script (latest version)
	PKG_DIR="$PKG"
	PKG_SCRIPT=""
	for foo in "$PKG_DIR"/*.sh; do
		if [ -f "$foo" ]; then
			PKG_SCRIPT="$foo"
		fi
	done
	PKG_SCRIPT=`basename "$PKG_SCRIPT"`
else
	echo "$PKG not found"
	exit 1
fi

echo "Preparing to build $PKG"

source "common/env.sh"

echo "Copying azusa-opensource-recipes ..."

rsync -a "$AZUSA_RECIPES_ROOT"/ "$tmp_dir/root/azusa-opensource-recipes/"

echo "Build..."

chroot "$tmp_dir" /bin/bash -c "cd /root/azusa-opensource-recipes/${PKG_DIR}; ./${PKG_SCRIPT}"

mkdir /tmp/apkg || true
mv -v "$tmp_dir/tmp/apkg"/* /tmp/apkg

# fix rights on /tmp/apkg to make sure user can upload
chown 1000 -R /tmp/apkg
