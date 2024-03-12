#!/bin/sh

# currently active python versions (for modules, etc)
PYTHON_VERSIONS="3.10.13 3.11.8 3.12.2"
PYTHON_LATEST="$(echo "$PYTHON_VERSIONS" | sed -e 's/.* //')"
#PYTHON_LATEST="$(echo $PYTHON_VERSIONS | awk 'NF>1{print $NF}')"

PYTHON_MODS="dev-python/setuptools dev-python/pip dev-util/gyp dev-util/meson dev-python/pycairo dev-python/pygobject dev-python/numpy dev-util/scons"

# (from gentoo, to clean/remove/reuse?)
# Stub out ez_setup.py and distribute_setup.py to prevent packages
# from trying to download a local copy of setuptools.
disable_ez_setup() {
    local stub="def use_setuptools(*args, **kwargs): pass"
    if [[ -f ez_setup.py ]]; then
        echo "${stub}" > ez_setup.py || die
    fi
    if [[ -f distribute_setup.py ]]; then
        echo "${stub}" > distribute_setup.py || die
    fi
}

logrun() {
	echo "Running: $@"
	"$@"
}

check_fail_location() {
	local T="$1"
	# check if location is empty after clearing legacy stuff, fail if not
	find "$T" -name azusafinder*.pyc | xargs rm -fv
	find "$T" -name __pycache__ -type d | xargs rmdir --ignore-fail-on-non-empty -v
	find "$T" -type c | xargs rm -fv # removed files are stored as character device files by overlayfs - we don't care about removed files
	find "$T" -empty -type d -delete
	if [ -e "$T" ]; then
		echo "*** FOUND FILES IN LEGACY LOCATION"
		find "$T" -ls
		exit 1
	fi
}

pythonsetup() {
	acheck

	mkdir -p "${D}/pkg/main"

	# perform install for all relevant versions of python
	for PYTHON_VERSION in $PYTHON_VERSIONS; do
		if [ x"$PYTHON_RESTRICT" != x ]; then
			# need to make sure PYTHON_VERSION starts with one of the values in PYTHON_RESTRICT
			python_found=0
			for foo in $PYTHON_RESTRICT; do
				if [[ "$PYTHON_VERSION" =~ ^$foo ]]; then
					python_found=1
					break
				fi
			done

			if [ $python_found -eq 0 ]; then
				echo "Skipping Python $PYTHON_VERSION due to PYTHON_RESTRICT"
				continue
			fi
		fi
		echo "Running for python-$PYTHON_VERSION"
		local PYTHON_VERSION_MINOR="$(echo "${PYTHON_VERSION}" | cut -d. -f1-2 )" # for python3.10.2 this will be 3.10
		local PYTHON_VERSION_MAJOR="$(echo "${PYTHON_VERSION}" | cut -d. -f1 )" # for python3.10.2 this will be 3
		local PYTHON_PACKAGES="/pkg/main/dev-lang.python-modules.core.${PYTHON_VERSION}.${OS}.${ARCH}/lib/python${PYTHON_VERSION_MINOR}/site-packages/azusafinder.py"

		export PYTHONHOME="/pkg/main/dev-lang.python.core.${PYTHON_VERSION}"
		export PYTHONPATH=":./site-packages:/pkg/main/dev-lang.python-modules.core.${PYTHON_VERSION}.${OS}.${ARCH}/lib/python${PYTHON_VERSION_MINOR}:/pkg/main/dev-lang.python-modules.core.${PYTHON_VERSION}/lib/python${PYTHON_VERSION_MINOR}/site-packages:$PYTHONHOME/lib/python${PYTHON_VERSION_MINOR}/lib-dynload"
		#export SETUPTOOLS_USE_DISTUTILS=stdlib

		echo " * PYTHONHOME=$PYTHONHOME"
		echo " * PYTHONPATH=$PYTHONPATH"

		#PIP_EXE="/pkg/main/dev-lang.python-modules.core.${PYTHON_VERSION}.${OS}.${ARCH}/bin/pip${PYTHON_VERSION_MAJOR}"
		PYTHON_EXE="/pkg/main/dev-lang.python.core.${PYTHON_VERSION}/bin/python${PYTHON_VERSION_MAJOR}"
		if [ "$(cat "$PYTHON_PACKAGES" | grep -c pip)" -gt 0 ]; then
			#"$PIP_EXE" install --no-binary=:all: --no-deps --no-clean --disable-pip-version-check --root "${D}" --prefix "/pkg/main/dev-lang.python-modules.core.${PYTHON_VERSION}.${OS}.${ARCH}" .
			#"$PIP_EXE" install --no-binary=:all: --no-deps --no-clean --disable-pip-version-check --root "${D}" --prefix "/pkg/main/${PKG}.mod.${PVR}.py${PYTHON_VERSION}" .
			#logrun "$PYTHON_EXE" -m pip list
			mkdir -p site-packages
			echo "import wheel" >site-packages/load_wheel.py
			echo "print(\"loaded wheel\")" >>site-packages/load_wheel.py
			echo "import load_wheel" >site-packages/load_wheel.pth
			logrun "$PYTHON_EXE" -m pip install --verbose --verbose --verbose --no-binary=:all: --no-build-isolation --no-cache-dir --no-deps --disable-pip-version-check --root "$D" --prefix "/pkg/main/${PKG}.mod.${PVR}.py${PYTHON_VERSION}.${OS}.${ARCH}" .
		else
			# if we don't have pip, fallback to using setup.py (required to install setuptools & pip)
			logrun "$PYTHON_EXE" setup.py install --root "${D}" --prefix="/pkg/main/${PKG}.mod.${PVR}.py${PYTHON_VERSION}.${OS}.${ARCH}" "$@"
		fi

		# fetch the installed module from /.pkg-main-rw/
		mkdir -p "${D}/pkg/main/${PKG}.mod.${PVR}.py${PYTHON_VERSION}.${OS}.${ARCH}"

		if [ -d "/.pkg-main-rw/dev-lang.python-modules.core.${PYTHON_VERSION}.${OS}.${ARCH}" ]; then
			check_fail_location "/.pkg-main-rw/dev-lang.python-modules.core.${PYTHON_VERSION}.${OS}.${ARCH}"
		elif [ -d "${D}/pkg/main/dev-lang.python-modules.core.${PYTHON_VERSION}.${OS}.${ARCH}" ]; then
			rsync -av --remove-source-files "${D}/pkg/main/dev-lang.python-modules.core.${PYTHON_VERSION}.${OS}.${ARCH}"/ "${D}/pkg/main/${PKG}.mod.${PVR}.py${PYTHON_VERSION}.${OS}.${ARCH}/"
		fi
		if [ -d "/.pkg-main-rw/dev-lang.python.libs.${PYTHON_VERSION}"* ]; then
			check_fail_location "/.pkg-main-rw/dev-lang.python.libs.${PYTHON_VERSION}"*
		fi
		if [ -d "/.pkg-main-rw/dev-lang.python.core.${PYTHON_VERSION}"* ]; then
			check_fail_location "/.pkg-main-rw/dev-lang.python.core.${PYTHON_VERSION}"*
		fi
	done
	find "${D}" -name azusafinder*.pyc | xargs rm -fv
	find "${D}" -name __pycache__ -type d | xargs rmdir --ignore-fail-on-non-empty -v
}

pythonpackage() {
	for PYTHON_VERSION in $PYTHON_VERSIONS; do
		if [ -d "/.pkg-main-rw/pkg/main/dev-lang.python-modules.core.${PYTHON_VERSION}.${OS}.${ARCH}" ]; then
			mv "/.pkg-main-rw/pkg/main/dev-lang.python-modules.core.${PYTHON_VERSION}.${OS}.${ARCH}" "${D}/pkg/main/${PKG}.mod.${PVR}.py${PYTHON_VERSION}.${OS}.${ARCH}/"
		fi
		if [ -d "/.pkg-main-rw/dev-lang.python.core.${PYTHON_VERSION}"* ]; then
			# maybe installed bin folder. Move it too
			mv "/.pkg-main-rw/dev-lang.python.core.${PYTHON_VERSION}"*/* "${D}/pkg/main/${PKG}.mod.${PVR}.py${PYTHON_VERSION}.${OS}.${ARCH}/"
		fi
	done
}

pythonmesonsetup() {
	# for pygobject, and maybe others?

	acheck

	mkdir -p "${D}/pkg/main"
	local base="$PWD"

	# perform install for all relevant versions of python
	for PYTHON_VERSION in $PYTHON_VERSIONS; do
		if [ x"$PYTHON_RESTRICT" != x ]; then
			# need to make sure PYTHON_VERSION starts with one of the values in PYTHON_RESTRICT
			python_found=0
			for foo in $PYTHON_RESTRICT; do
				if [[ "$PYTHON_VERSION" =~ ^$foo ]]; then
					python_found=1
					break
				fi
			done

			if [ $python_found -eq 0 ]; then
				echo "Skipping Python $PYTHON_VERSION due to PYTHON_RESTRICT"
				continue
			fi
		fi

		mkdir -p "${T}/build-${PYTHON_VERSION}"
		cd "${T}/build-${PYTHON_VERSION}"
		meson --prefix="/pkg/main/${PKG}.mod.${PVR}.py${PYTHON_VERSION}" -Dpython="/pkg/main/dev-lang.python.core.${PYTHON_VERSION}/bin/python${PYTHON_VERSION:0:1}" "$base"
		ninja
		DESTDIR="${D}" ninja install

		if [ -d "${D}/pkg/main/${PKG}.mod.${PVR}.py${PYTHON_VERSION}/lib/pkgconfig" ]; then
			mv "${D}/pkg/main/${PKG}.mod.${PVR}.py${PYTHON_VERSION}/lib/pkgconfig" "${D}/pkg/main/${PKG}.mod.${PVR}.py${PYTHON_VERSION}/pkgconfig"
			# try to remove lib if empty
			rmdir "${D}/pkg/main/${PKG}.mod.${PVR}.py${PYTHON_VERSION}/lib" || true
		fi

		# fetch the installed module from /.pkg-main-rw/
		#mv "/.pkg-main-rw/dev-lang.python-modules.core.${PYTHON_VERSION}".* "${D}/pkg/main/${PKG}.mod.${PVR}.py${PYTHON_VERSION}"
	done
}

pythonconfsetup() {
	# for pygobject, and maybe others?

	acheck

	mkdir -p "${D}/pkg/main"
	local base="$PWD"

	# perform install for all relevant versions of python
	for PYTHON_VERSION in $PYTHON_VERSIONS; do
		if [ x"$PYTHON_RESTRICT" != x ]; then
			# need to make sure PYTHON_VERSION starts with one of the values in PYTHON_RESTRICT
			python_found=0
			for foo in $PYTHON_RESTRICT; do
				if [[ "$PYTHON_VERSION" =~ ^$foo ]]; then
					python_found=1
					break
				fi
			done

			if [ $python_found -eq 0 ]; then
				echo "Skipping Python $PYTHON_VERSION due to PYTHON_RESTRICT"
				continue
			fi
		fi

		mkdir -p "${T}/build-${PYTHON_VERSION}"
		cd "${T}/build-${PYTHON_VERSION}"
		PYTHON="/pkg/main/dev-lang.python.core.${PYTHON_VERSION}/bin/python${PYTHON_VERSION:0:1}" "$base/configure" --prefix="/pkg/main/${PKG}.mod.${PVR}.py${PYTHON_VERSION}" "$@"
		make
		make install DESTDIR="${D}"

		if [ -d "${D}/pkg/main/${PKG}.mod.${PVR}.py${PYTHON_VERSION}/lib/pkgconfig" ]; then
			mv "${D}/pkg/main/${PKG}.mod.${PVR}.py${PYTHON_VERSION}/lib/pkgconfig" "${D}/pkg/main/${PKG}.mod.${PVR}.py${PYTHON_VERSION}/pkgconfig"
			# try to remove lib if empty
			rmdir "${D}/pkg/main/${PKG}.mod.${PVR}.py${PYTHON_VERSION}/lib" || true
		fi

		# fetch the installed module from /.pkg-main-rw/
		#mv "/.pkg-main-rw/dev-lang.python-modules.core.${PYTHON_VERSION}".* "${D}/pkg/main/${PKG}.mod.${PVR}.py${PYTHON_VERSION}"
	done
}

python_domodule() {
	for PYTHON_VERSION in $PYTHON_VERSIONS; do
		if [ x"$PYTHON_RESTRICT" != x ]; then
			# need to make sure PYTHON_VERSION starts with one of the values in PYTHON_RESTRICT
			python_found=0
			for foo in $PYTHON_RESTRICT; do
				if [[ "$PYTHON_VERSION" =~ ^$foo ]]; then
					python_found=1
					break
				fi
			done

			if [ $python_found -eq 0 ]; then
				echo "Skipping Python $PYTHON_VERSION due to PYTHON_RESTRICT"
				continue
			fi
		fi
		mkdir -pv "${D}/pkg/main/${PKG}.mod.${PVR}.py${PYTHON_VERSION}.${OS}.${ARCH}/lib/python${PYTHON_VERSION%.*}/site-packages"
		cp -avr "$1" "${D}/pkg/main/${PKG}.mod.${PVR}.py${PYTHON_VERSION}.${OS}.${ARCH}/lib/python${PYTHON_VERSION%.*}/site-packages"
	done
}

pythondownload() {
	local PN="$1"
	local PV="$2"
	URL="$(curl -s "https://pypi.org/pypi/$PN/$PV/json" | jq -r '.urls[] | select(.python_version=="source") | .url')"
	if [ x"$URL" != x ]; then
		get "$URL"
	else
		get https://pypi.org/packages/source/\${PN:0:1}/\${PN}/\${P}.tar.gz
	fi
}

python_do_standard_package() {
	# perform all the steps for a python package
	pythondownload "$PN" "$PV"
	acheck

	cd "${S}"

	pythonsetup
	archive
}
