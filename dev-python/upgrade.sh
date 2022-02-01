#!/bin/sh
set -e

for foo in */; do
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

	cat >"$BASE/azusa.yaml" <<EOF
description: $SUMMARY
homepage: $HOMEPAGE
license: $LICENSE
EOF

	if [ x"$FILTVERS" = x"$LATEST_VERS" ]; then
		echo "No update needed"
		continue
	fi

	echo "New version found: $LATEST_VERS"

	rm -f "$BASE/$BASE-$FILTVERS.sh"
	cat >"$BASE/$BASE-$LATEST_VERS.sh" <<EOF
#!/bin/sh
source ../../common/init.sh
source \${ROOTDIR}/common/python.sh

get https://pypi.org/packages/source/\${PN:0:1}/\${PN}/\${P}.tar.gz
acheck

cd "\${P}"

pythonsetup
archive
EOF
	chmod +x "$BASE/$BASE-$LATEST_VERS.sh"

	# trigger download
	cd "$BASE"
	"./$BASE-$LATEST_VERS.sh" || true
	cd ..
	#exit
done
