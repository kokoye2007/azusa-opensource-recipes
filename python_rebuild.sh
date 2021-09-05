#!/bin/sh
ROOTDIR="`pwd`"
source "common/init.sh"
inherit python
acheck

for PYTHON_VERSION in $PYTHON_VERSIONS; do
	echo "Checking modules for python $PYTHON_VERSION"
	MODS=`curl -s http://localhost:100/apkgdb/main?action=list | grep "py$PYTHON_VERSION" || true`

	for foo in $ROOTDIR/dev-python/*; do
		echo "$foo"
		BASE=`basename "$foo"`
		if [ `echo "$MODS" | grep -c "$BASE\\.mod"` -gt 0 ]; then
			# already have
			continue
		fi
		# detect version
		VERS=""
		for V in "$foo/$BASE"-*.sh; do
			if [ -f "$V" ]; then
				VERS="$V"
			fi
		done
		if [ x"$VERS" = x ]; then
			echo "No version found for dev-python/$BASE"
			continue
		fi
		echo "Will attempt to build dev-python/$BASE"
		yes 'n' | "$ROOTDIR/common/build.sh" "dev-python/$BASE/$(basename "$VERS")" || true
	done
done
