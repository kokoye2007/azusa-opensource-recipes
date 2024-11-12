#!/bin/sh
ROOTDIR="$(pwd)"
source "common/init.sh"
inherit perl
acheck

for PERL_VERSION in $PERL_VERSIONS; do
	echo "Checking modules for perl $PERL_VERSION"
	MODS=$(curl -s http://localhost:100/apkgdb/main?action=list | grep "perl$PERL_VERSION" || true)

	for foo in $ROOTDIR/dev-perl/*; do
		echo "$foo"
		BASE=$(basename "$foo")
		if [ $(echo "$MODS" | grep -c "$BASE\\.mod") -gt 0 ]; then
			# already have
			#continue
			:
		fi
		# detect version
		VERS=""
		for V in "$foo/$BASE"-*.sh; do
			if [ -f "$V" ]; then
				VERS="$V"
			fi
		done
		if [ "$VERS" = "" ]; then
			echo "No version found for dev-perl/$BASE"
			continue
		fi
		echo "Will attempt to build dev-perl/$BASE"
		yes 'n' | "$ROOTDIR/common/build.sh" "dev-perl/$BASE/$(basename "$VERS")" || true
	done
done
