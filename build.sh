#!/bin/sh
cd "$(dirname $0)"
set -e

if [ `id -u` -eq 0 ]; then
	exec ./common/build.sh "$@"
	exit $?
fi

# we're not root, attempt to run script locally
AZUSA_RECIPES_ROOT=`pwd`

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

echo "Running $PKG"

cd ${PKG_DIR}
exec ./${PKG_SCRIPT}
