#!/bin/sh
source ../../common/init.sh
source "${ROOTDIR}"/common/python.sh

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
	echo "import importlib.abc" >"$FINDER"
	echo "import importlib.machinery" >>"$FINDER"
	echo "import sys" >>"$FINDER"
	echo >>"$FINDER"
	echo "class AzusaModuleFinder(importlib.abc.MetaPathFinder):" >>"$FINDER"
	echo "    def __init__(self):" >>"$FINDER"
	echo "        self.modules = {" >>"$FINDER"

	unset modules
	unset modpaths
	declare -A modules
	declare -A modpaths

	for pn in $(curl -s "http://localhost:100/apkgdb/main?action=list&sub=${OS}.${ARCH}" | grep "py$PYTHON_VERSION"); do
		p=/pkg/main/${pn}
		t=$(echo "$pn" | cut -d. -f3)
		n=$(echo "$pn" | cut -d. -f2)

		if [ x"$t" != x"mod" ]; then
			# skip if not a module
			continue
		fi
		modpaths[$n]=${pn}
	done

	for n in ${!modpaths[@]}; do
		pn=${modpaths[$n]}
		p=/pkg/main/${pn}

		echo " * Module: $pn"
		modpath="lib/python${PYTHON_MINOR}/site-packages"
		modskip=""

		# handle some special cases
		case $pn in
			media-libs.usd.mod.*)
				# usd has python modules in this path:
				modpath="lib/python"
				;;
			dev-util.scons.mod.*)
				modpath="lib/scons"
				;;
			dev-python.attr.mod.*)
				# this module shouldn't be added for "attr", only "dry_attr"
				modskip="attr"
				;;
		esac

		if [ -d "${p}/$modpath" ]; then
			for foo in "${p}/$modpath"/*/; do
				foo="$(basename "$foo")"
				if [ "$foo" == "$modskip" ]; then
					continue
				fi
				case "$foo" in
					'*'|__pycache__)
						:
						;;
					*.egg-info|*.dist-info)
						:
						;;
					*.egg)
						# python_nghttp2-1.50.0-py3.10-linux-x86_64.egg
						foo="$(echo "$foo" | cut -d- -f1)"
						modules[$foo]="${modules[$foo]} ${p}/$modpath"
						;;
					*)
						modules[$foo]="${modules[$foo]} ${p}/$modpath"
						;;
				esac
			done
			for foo in "${p}/$modpath"/*.py; do
				foo="$(basename "$foo" .py)"
				if [ "$foo" == "$modskip" ]; then
					continue
				fi
				if [ "$foo" != "*" ]; then
					modules[$foo]="${modules[$foo]} ${p}/$modpath"
				fi
			done
			# copy package infos
			for foo in "${p}/$modpath"/*.{egg,dist}-info; do
				if [ -e "$foo" ]; then
					cp -r "$foo" -t "$TARGET"
				fi
			done
		else
			echo "no modules found!"
		fi
		#cp -rsfT "$p" "$TARGET"
	done

	# iterate over modules
	for mod in ${!modules[@]}; do
		echo -n "            '$mod': [" >>"$FINDER"
		for p in ${modules[$mod]}; do
			echo -n "'$p'," >>"$FINDER"
		done
		echo "]," >>"$FINDER"
	done

	echo "        }" >>"$FINDER"
	echo "    def find_spec(self, fullname, path=None, target=None):" >>"$FINDER"
	echo "        \"\"\"Find the path of the given module in the static list.\"\"\"" >>"$FINDER"
	echo "        if fullname == 'distutils':" >>"$FINDER"
	echo "            finder = __import__('_distutils_hack').DistutilsMetaFinder()" >>"$FINDER"
	echo "            return finder.spec_for_distutils()" >>"$FINDER"
	echo "        if fullname in self.modules:" >>"$FINDER"
	echo "            module_paths = self.modules[fullname]" >>"$FINDER"
	echo "            for module_path in module_paths:" >>"$FINDER"
	echo "                if module_path not in sys.path:" >>"$FINDER"
	echo "                    sys.path.append(module_path)" >>"$FINDER"
	echo "        return None" >>"$FINDER"
	echo >>"$FINDER"
	echo "sys.meta_path.insert(0, AzusaModuleFinder())" >>"$FINDER"

	# autoload finder
	echo "import azusafinder" >"${D}/pkg/main/${PKG}.core.${PYTHON_VERSION}/lib/python${PYTHON_MINOR}/site-packages/azusafinder.pth"
done

archive
