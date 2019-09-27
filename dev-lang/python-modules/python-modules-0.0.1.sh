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
	cp -rsf "$MODP"/* "$TARGET"
done

for MOD in $PYTHON_MODS; do
	# dev-python.setuptools.mod.41.2.0.py3.7.3.linux.amd64
	MODPATH="${MOD//\//.}.mod"
	FULL=`readlink "/pkg/main/$MODPATH"`
	VERSION=`echo ${FULL//$MODPATH./} | sed -e 's/\.py.*//'`
	echo "Grabbing module $MOD version $VERSION"

	for PYTHON_VERSION in $PYTHON_VERSIONS; do
		FULLPATH="/pkg/main/${MODPATH}.${VERSION}.py${PYTHON_VERSION}"
		if [ ! -d "$FULLPATH/" ]; then
			echo " * Python ${PYTHON_VERSION} is MISSING, please rebuild ${MOD}"
			continue
		fi
		echo " * Python ${PYTHON_VERSION}"
		TARGET="${D}/pkg/main/${PKG}.core.${PYTHON_VERSION}"
		mkdir -p "$TARGET"

		cp -rsf "$FULLPATH"/* "$TARGET"
	done
done

finalize
