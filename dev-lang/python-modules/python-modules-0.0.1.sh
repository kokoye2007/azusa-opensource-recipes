#!/bin/sh
source ../../common/init.sh
source ${ROOTDIR}/common/python.sh

# this will compile & generate python-modules package for each listed version of python

for PYTHON_VERSION in $PYTHON_VERSIONS; do
	echo "Generating for $PYTHON_VERSION ..."

	TARGET="${D}/pkg/main/${PKG}.core.${PYTHON_VERSION}"
	mkdir -p "${TARGET}"

	# generate path from /pkg/main/dev-lang.python.mod.${PYTHON_VERSION}

	MODP="/pkg/main/dev-lang.python.mod.${PYTHON_VERSION}"
	cp -rsfT "$MODP"/ "$TARGET"

	for pn in `curl -s http://localhost:100/apkgdb/main?action=list | grep "py$PYTHON_VERSION"`; do
		p=/pkg/main/${pn}
		t=`echo "$pn" | cut -d. -f3`

		if [ x"$t" != x"mod" ]; then
			# skip if not a module
			continue
		fi

		echo " * Module: $pn"
		cp -rsfT "$p" "$TARGET"
	done
done

finalize
