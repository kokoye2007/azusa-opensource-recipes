#!/bin/sh
source ../../common/init.sh
source ${ROOTDIR}/common/python.sh

acheck

# this will compile & generate python-modules package for each listed version of python

for PYTHON_VERSION in $PYTHON_VERSIONS; do
	echo "Generating for $PYTHON_VERSION ..."

	TARGET="${D}/pkg/main/${PKG}.core.${PYTHON_VERSION}"
	mkdir -p "${TARGET}"

	# generate path from /pkg/main/dev-lang.python.mod.${PYTHON_VERSION}

	MODP="/pkg/main/dev-lang.python.mod.${PYTHON_VERSION}.${OS}.${ARCH}"
	cp -rsfT "$MODP"/ "$TARGET"

	for pn in `curl -s "http://localhost:100/apkgdb/main?action=list&sub=${OS}.${ARCH}" | grep "py$PYTHON_VERSION"`; do
		p=/pkg/main/${pn}
		t=`echo "$pn" | cut -d. -f3`

		if [ x"$t" != x"mod" ]; then
			# skip if not a module
			continue
		fi

		echo " * Module: $pn"
		cp -rsfT "$p" "$TARGET"
	done

	# /pkg/main/dev-lang.python-modules.core.3.7/lib/python3.7/site-packages/setuptools.pth
	# re-generate setuptools.pth file
	if [ -d "${TARGET}/lib/python${PYTHON_VERSION%.*}/site-packages" ]; then
		cd "${TARGET}/lib/python${PYTHON_VERSION%.*}/site-packages"
		rm -f setuptools.pth easy-install.pth
		find . -maxdepth 1 -name '*.egg' | sort -r | sort -u --field-separator=- -k 1,1 >setuptools.pth
		cp setuptools.pth easy-install.pth
	fi
done

archive
