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

	# locate packages
	for pn in `curl -s http://localhost:100/apkgdb/main?action=list | grep "perl$PERL_VERSION"`; do
		p=/pkg/main/${pn}
		t=`echo "$pn" | cut -d. -f3`

		if [ x"$t" != x"mod" ]; then
			# skip if not a module
			continue
		fi

		# copy
		echo " * Module: $pn"
		cp -rsfT "${p}" "${TARGET}"
	done
done

finalize
