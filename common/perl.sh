#!/bin/sh

# currently active perl versions (for modules, etc)
PERL_VERSIONS="5.36.1"

PERL_MODS=""

perlsetup() {
	if [ ! -d /.pkg-main-rw ]; then
		echo "This needs to be built in Azusa Build env"
		exit 1
	fi

	mkdir -p "${D}/pkg/main"

	# perform install for all relevant versions of perl
	for PERL_VERSION in $PERL_VERSIONS; do
		if [ -f Makefile.PL ]; then
			"/pkg/main/dev-lang.perl.core.${PERL_VERSION}/bin/perl" Makefile.PL "$@"
			sed -i "/^INSTALL/s/dev-lang\.perl-modules\.core\.${PERL_VERSION}\.$OS\.$ARCH/${PKG}.mod.${PVR}.perl${PERL_VERSION}.${OS}.${ARCH}/" Makefile
			sed -i "/^INSTALL/s/dev-lang\.perl-modules\.doc\.${PERL_VERSION}\.$OS\.$ARCH/${PKG}.doc.${PVR}.perl${PERL_VERSION}.${OS}.${ARCH}/" Makefile
			sed -i "/^INSTALL/s/dev-lang\.perl\.core\.${PERL_VERSION}\.$OS\.$ARCH/${PKG}.mod.${PVR}.perl${PERL_VERSION}.${OS}.${ARCH}/" Makefile
			sed -i "/^INSTALL/s/dev-lang\.perl\.doc\.${PERL_VERSION}\.$OS\.$ARCH/${PKG}.doc.${PVR}.perl${PERL_VERSION}.${OS}.${ARCH}/" Makefile
			make
			make install DESTDIR="${D}"
		elif [ -f Build.PL ]; then
			"/pkg/main/dev-lang.perl.core.${PERL_VERSION}/bin/perl" Build.PL "$@"
			./Build
			./Build install
		else
			echo "no build file"
			exit 1
		fi

		# fetch the installed module from /.pkg-main-rw/
		for typ in core doc; do
			ttyp="$typ"
			if [ x"$ttyp" = x"core" ]; then
				ttyp="mod"
			fi
			if [ -d "/.pkg-main-rw/dev-lang.perl-modules.$typ.${PERL_VERSION}"* ]; then
				mv "/.pkg-main-rw/dev-lang.perl-modules.$typ.${PERL_VERSION}"* "${D}/pkg/main/${PKG}.$ttyp.${PVR}.perl${PERL_VERSION}"
			fi
			if [ -d "${D}/pkg/main/dev-lang.perl-modules.$typ.${PERL_VERSION}"* ]; then
				mv "${D}/pkg/main/dev-lang.perl-modules.$typ.${PERL_VERSION}"* "${D}/pkg/main/${PKG}.$ttyp.${PVR}.perl${PERL_VERSION}"
			fi
		done

		if [ -f Makefile ]; then
			make distclean
		fi
	done
}
