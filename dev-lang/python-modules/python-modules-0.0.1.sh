#!/bin/sh
source ../../common/init.sh

# this will compile & generate python-modules package for each listed version of python
PYTHON_VERSIONS="2.7.16 3.7.3"

for PYTHON_VERSION in $PYTHON_VERSIONS; do
	echo "Generating for $PYTHON_VERSION ..."

	TARGET="${D}/pkg/main/${PKG}.${PYTHON_VERSION}"
	mkdir -p "${TARGET}"

	# generate path from /pkg/main/dev-lang.python.mod.${PYTHON_VERSION}

	MODP="/pkg/main/dev-lang.python.mod.${PYTHON_VERSION}"

	find "$MODP/" -type f -printf "%P\n" | while read foo; do
		foo_dir=`dirname "$foo"`
		if [ ! -d "$TARGET/$foo_dir" ]; then
			mkdir -p "$TARGET/$foo_dir"
		fi
		ln -snf "$MODP/$foo" "$TARGET/$foo"
	done
done

finalize
