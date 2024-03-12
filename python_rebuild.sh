#!/bin/sh
ROOTDIR="`pwd`"
source "common/init.sh"
inherit python
acheck

echo "Checking modules for python $PYTHON_LATEST"
MODS=`curl -s "http://localhost:100/apkgdb/main?action=list&sub=${OS}.${ARCH}" | grep "py$PYTHON_LATEST" || true`

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

exit

# check extra mods (python stuff that is not inside dev-python)
EXTRA_MODS="$(curl -s "http://localhost:100/apkgdb/main?action=list&sub=${OS}.${ARCH}" | grep '\.mod\.'  | grep '\.py' | grep -v "\\.py$PYTHON_LATEST" | cut -d. -f1-2 | sort -u | grep -v '^dev-python' | sed -e 's#\.#/#')"
for foo in $EXTRA_MODS; do
	if [ "$foo" = "dev-lang/python" ]; then
		# exclude python itself from check
		continue
	fi
	echo "extra: $foo"
	BASE=`basename "$foo"`
	PKGNAME="$(echo "$foo" | sed -e 's#/#.#')" # as pkg name
	if [ `echo "$MODS" | grep -c "$BASE\\.mod"` -gt 0 ]; then
		# already have
		continue
	fi
	# detect version
	VERS=""
	for V in "$ROOTDIR/$foo/$BASE"-*.sh; do
		if [ -f "$V" ]; then
			VERS="$V"
		fi
	done
	if [ x"$VERS" = x ]; then
		echo "No version found for $foo"
		continue
	fi
	echo "Will attempt to build $foo"
	yes 'n' | "$ROOTDIR/common/build.sh" "$foo/$(basename "$VERS")" || true
done
