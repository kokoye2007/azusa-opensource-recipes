#!/bin/sh

# currently active perl versions (for modules, etc)
PERL_VERSIONS="5.30.1"

PERL_MODS=""

perlsetup() {
	if [ ! -d /.pkg-main-rw ]; then
		echo "This needs to be built in Azusa Build env"
		exit 1
	fi

	mkdir -p "${D}/pkg/main"

	# perform install for all relevant versions of python
	for PERL_VERSION in $PERL_VERSIONS; do
		if [ -f Makefile.PL ]; then
			"/pkg/main/dev-lang.perl.core.${PERL_VERSION}/bin/perl" Makefile.PL "$@"
			make
			make install
		elif [ -f Build.PL ]; then
			"/pkg/main/dev-lang.perl.core.${PERL_VERSION}/bin/perl" Build.PL "$@"
			./Build
			./Build install
		else
			echo "no build file"
			exit 1
		fi

		# fetch the installed module from /.pkg-main-rw/
		mv "/.pkg-main-rw/dev-lang.perl-modules.core.${PERL_VERSION}"* "${D}/pkg/main/${PKG}.mod.${PVR}.perl${PERL_VERSION}"
		if [ -d "/.pkg-main-rw/dev-lang.perl-modules.doc.${PERL_VERSION}"* ]; then
			mv "/.pkg-main-rw/dev-lang.perl-modules.doc.${PERL_VERSION}"* "${D}/pkg/main/${PKG}.doc.${PVR}.perl${PERL_VERSION}"
		fi

		if [ -f Makefile ]; then
			make distclean
		fi
	done
}
