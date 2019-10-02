#!/bin/sh
source ../../common/init.sh
inherit perl

# this will compile & generate perl-modules package for each listed version of perl

for PERL_VERSION in $PERL_VERSIONS; do
	echo "Generating for $PERL_VERSION ..."

	TARGET="${D}/pkg/main/${PKG}.core.${PERL_VERSION}"
	mkdir -p "${TARGET}"

	# generate path from /pkg/main/dev-lang.perl.mod.${PERL_VERSION}

	MODP="/pkg/main/dev-lang.perl.mod.${PERL_VERSION}"
	cp -rsf "$MODP"/* "$TARGET"
done

for MOD in $PERL_MODS; do
	MODPATH="${MOD//\//.}.mod"
	FULL=`readlink "/pkg/main/$MODPATH"`
	VERSION=`echo ${FULL//$MODPATH./} | sed -e 's/\.py.*//'`
	echo "Grabbing module $MOD version $VERSION"

	for PERL_VERSION in $PERL_VERSIONS; do
		FULLPATH="/pkg/main/${MODPATH}.${VERSION}.perl${PERL_VERSION}"
		if [ ! -d "$FULLPATH/" ]; then
			echo " * Perl ${PERL_VERSION} is MISSING, please rebuild ${MOD}"
			continue
		fi
		echo " * Perl ${PERL_VERSION}"
		TARGET="${D}/pkg/main/${PKG}.core.${PERL_VERSION}"
		mkdir -p "$TARGET"

		cp -rsf "$FULLPATH"/* "$TARGET"
	done
done

finalize
