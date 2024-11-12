#!/bin/sh
set -e

pycheck() {
	foo="$1"
	# detect version
	VERS=""
	BASE="$(basename "$foo")"
	for V in "$foo/$BASE"-*.sh; do
		if [ -f "$V" ]; then
			VERS="$V"
		fi
	done
	FILTVERS="$(echo "$VERS" | sed -e 's/.*-//' | sed -e 's/\.sh//')"
	echo -n "Checking $BASE version $FILTVERS ..."

	# grab package info
	INFO="$(curl -s "https://pypi.org/pypi/$(echo "$BASE" | sed -e 's/_/-/g')/json")"
	LATEST_VERS="$(echo "$INFO" | jq -r .info.version)"

	# build azusa.yaml
	SUMMARY="$(echo "$INFO" | jq -r .info.summary)"
	HOMEPAGE="$(echo "$INFO" | jq -r .info.home_page)"
	LICENSE="$(echo "$INFO" | jq -r .info.license)"

	mkdir -p "$BASE"

	cat >"$BASE/azusa.yaml" <<EOF
description: $SUMMARY
homepage: $HOMEPAGE
license: $LICENSE
EOF

	if [ "$FILTVERS" = "$LATEST_VERS" ]; then
		echo "No update needed"
		return
	fi

	echo "New version found: $LATEST_VERS"

	# keep file contents if upgrade
	if [ -f "$BASE/$BASE-$FILTVERS.sh" ]; then
		mv "$BASE/$BASE-$FILTVERS.sh" "$BASE/$BASE-$LATEST_VERS.sh"
	else
		cat >"$BASE/$BASE-$LATEST_VERS.sh" <<EOF
#!/bin/sh
source ../../common/init.sh
inherit python

python_do_standard_package
EOF
	fi

	chmod +x "$BASE/$BASE-$LATEST_VERS.sh"

	# trigger download
	cd "$BASE"
	"./$BASE-$LATEST_VERS.sh" || true
	cd ..
	#exit
}

if [ "$1" != "" ]; then
	pycheck "$1"
	exit $?
fi

for foo in */; do
	pycheck "$foo"
done
