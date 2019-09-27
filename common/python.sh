#!/bin/sh

# currently active python versions (for modules, etc)
PYTHON_VERSIONS="2.7.16 3.5.7 3.6.9 3.7.4"

PYTHON_MODS="dev-python/setuptools dev-python/pip dev-util/gyp dev-util/meson dev-python/pycairo dev-python/pygobject dev-python/numpy"

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
	if [ ! -d /.pkg-main-rw ]; then
		echo "This needs to be built in Azusa Build env"
		exit
	fi

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
		"/pkg/main/dev-lang.python.core.${PYTHON_VERSION}/bin/python${PYTHON_VERSION:0:1}" setup.py install

		# fetch the installed module from /.pkg-main-rw/
		mv "/.pkg-main-rw/dev-lang.python-modules.core.${PYTHON_VERSION}".* "${D}/pkg/main/${PKG}.mod.${PVR}.py${PYTHON_VERSION}"
	done
}
