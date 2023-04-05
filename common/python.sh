#!/bin/sh

# currently active python versions (for modules, etc)
PYTHON_VERSIONS="3.8.16 3.9.16 3.10.11"
PYTHON_LATEST="$(echo "$PYTHON_VERSIONS" | sed -e 's/.* //')"

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
		export PYTHONHOME="/pkg/main/dev-lang.python.core.${PYTHON_VERSION}"
		export PYTHONPATH=":/pkg/main/dev-lang.python-modules.core.${PYTHON_VERSION}/lib/python${PYTHON_VERSION_MINOR}:$PYTHONHOME/lib/python${PYTHON_VERSION_MINOR}/lib-dynload"
		export SETUPTOOLS_USE_DISTUTILS=stdlib
		"/pkg/main/dev-lang.python.core.${PYTHON_VERSION}/bin/python${PYTHON_VERSION_MAJOR}" setup.py install --root "${D}" --prefix="/pkg/main/${PKG}.mod.${PVR}.py${PYTHON_VERSION}" "$@"

		# fetch the installed module from /.pkg-main-rw/
		if [ -d "/.pkg-main-rw/dev-lang.python-modules.core.${PYTHON_VERSION}".* ]; then
			mv -v "/.pkg-main-rw/dev-lang.python-modules.core.${PYTHON_VERSION}".* "${D}/pkg/main/${PKG}.mod.${PVR}.py${PYTHON_VERSION}"
		else
			mkdir -p "${D}/pkg/main/${PKG}.mod.${PVR}.py${PYTHON_VERSION}"
		fi
		if [ -d "/.pkg-main-rw/dev-lang.python.libs.${PYTHON_VERSION}"* ]; then
			# maybe installed lib folder here. Move it too
			cp -arv "/.pkg-main-rw/dev-lang.python.libs.${PYTHON_VERSION}"*/* "${D}/pkg/main/${PKG}.mod.${PVR}.py${PYTHON_VERSION}/"
		fi
		if [ -d "/.pkg-main-rw/dev-lang.python.core.${PYTHON_VERSION}"* ]; then
			# maybe installed bin folder. Move it too
			cp -arv "/.pkg-main-rw/dev-lang.python.core.${PYTHON_VERSION}"*/* "${D}/pkg/main/${PKG}.mod.${PVR}.py${PYTHON_VERSION}/"
		fi
	done
}

pythonpackage() {
	for PYTHON_VERSION in $PYTHON_VERSIONS; do
		if [ -d "/.pkg-main-rw/pkg/main/dev-lang.python-modules.core.${PYTHON_VERSION}.${OS}.${ARCH}" ]; then
			mv "/.pkg-main-rw/pkg/main/dev-lang.python-modules.core.${PYTHON_VERSION}.${OS}.${ARCH}" "${D}/pkg/main/${PKG}.mod.${PVR}.py${PYTHON_VERSION}/"
		fi
		if [ -d "/.pkg-main-rw/dev-lang.python.core.${PYTHON_VERSION}"* ]; then
			# maybe installed bin folder. Move it too
			mv "/.pkg-main-rw/dev-lang.python.core.${PYTHON_VERSION}"*/* "${D}/pkg/main/${PKG}.mod.${PVR}.py${PYTHON_VERSION}/"
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
