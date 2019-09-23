#!/bin/sh

# currently active python versions (for modules, etc)
PYTHON_VERSIONS="2.7.16 3.7.3"

PYTHON_MODS="dev-python/setuptools"

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
