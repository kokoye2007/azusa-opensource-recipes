#!/bin/sh
source ../../common/init.sh
source ${ROOTDIR}/common/python.sh

get https://pypi.org/packages/source/${PN:0:1}/${PN}/${P}.zip

cd "${P}"
mkdir -p "${D}/pkg/main"

# perform install for all relevant versions of python
for PYTHON_VERSION in $PYTHON_VERSIONS; do
	"/pkg/main/dev-lang.python.core.${PYTHON_VERSION}/bin/python${PYTHON_VERSION:0:1}" setup.py install

	# fetch the installed module from /.pkg-main-rw/
	mv "/.pkg-main-rw/dev-lang.python-modules.${PYTHON_VERSION}".* "${D}/pkg/main/${PKG}.mod.${PVR}.py${PYTHON_VERSION}"
done

archive
