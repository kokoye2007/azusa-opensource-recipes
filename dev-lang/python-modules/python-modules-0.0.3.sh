#!/bin/sh
source ../../common/init.sh
source ${ROOTDIR}/common/python.sh

acheck

# this will compile & generate python-modules package for each listed version of python

for PYTHON_VERSION in $PYTHON_VERSIONS; do
	echo "Generating for $PYTHON_VERSION ..."
	PYTHON_MINOR="${PYTHON_VERSION%.*}" # 3.10

	TARGET="${D}/pkg/main/${PKG}.core.${PYTHON_VERSION}/lib/python${PYTHON_MINOR}/site-packages"
	mkdir -p "${TARGET}"

	# link python includes
	MODP="/pkg/main/dev-lang.python.mod.${PYTHON_VERSION}.${OS}.${ARCH}"
	cp -rsfT "$MODP"/ "$TARGET/../../../"

	# generate path for python itself
	echo "/pkg/main/dev-lang.python.mod.${PYTHON_VERSION}.${OS}.${ARCH}/lib/python${PYTHON_MINOR}" >"$TARGET/python.pth"
	echo "/pkg/main/dev-lang.python.libs.${PYTHON_VERSION}.${OS}.${ARCH}/lib/python${PYTHON_MINOR}/lib-dynload" >>"$TARGET/python.pth"

	# generate finder
	FINDER="${D}/pkg/main/${PKG}.core.${PYTHON_VERSION}/lib/python${PYTHON_MINOR}/site-packages/azusafinder.py"
	echo "import importlib.abc" >$FINDER
	echo "import importlib.machinery" >>$FINDER
	echo "import sys" >>$FINDER
	echo >>$FINDER
	echo "class AzusaModuleFinder(importlib.abc.MetaPathFinder):" >>$FINDER
	echo "    def __init__(self):" >>$FINDER
	echo "        self.modules = {" >>$FINDER


	for pn in `curl -s "http://localhost:100/apkgdb/main?action=list&sub=${OS}.${ARCH}" | grep "py$PYTHON_VERSION"`; do
		p=/pkg/main/${pn}
		t=`echo "$pn" | cut -d. -f3`

		if [ x"$t" != x"mod" ]; then
			# skip if not a module
			continue
		fi

		echo " * Module: $pn"
		if [ -d "${p}/lib/python${PYTHON_MINOR}/site-packages" ]; then
			for foo in "${p}/lib/python${PYTHON_MINOR}/site-packages"/*/__init__.py; do
				foo="$(basename "$(dirname "$foo")")"
				if [ "$foo" != "*" ]; then
					echo "            '$foo': '${p}/lib/python${PYTHON_MINOR}/site-packages'," >>$FINDER
				fi
			done
			for foo in "${p}/lib/python${PYTHON_MINOR}/site-packages"/*.py; do
				foo="$(basename "$foo" .py)"
				if [ "$foo" != "*" ]; then
					echo "            '$foo': '${p}/lib/python${PYTHON_MINOR}/site-packages'," >>$FINDER
				fi
			done
		else
			echo "no modules found!"
		fi
		#cp -rsfT "$p" "$TARGET"
	done

	echo "        }" >>$FINDER
	echo "    def find_spec(self, fullname, path=None, target=None):" >>$FINDER
	echo "        \"\"\"Find the path of the given module in the static list.\"\"\"" >>$FINDER
	echo "        if fullname in self.modules:" >>$FINDER
	echo "            module_path = self.modules[fullname]" >>$FINDER
	echo "            if module_path not in sys.path:" >>$FINDER
	echo "                sys.path.append(module_path)" >>$FINDER
	echo "        return None" >>$FINDER
	echo >>$FINDER
	echo "sys.meta_path.insert(0, AzusaModuleFinder())" >>$FINDER

	# autoload finder
	echo "import azusafinder" >"${D}/pkg/main/${PKG}.core.${PYTHON_VERSION}/lib/python${PYTHON_MINOR}/site-packages/azusafinder.pth"
done

archive
