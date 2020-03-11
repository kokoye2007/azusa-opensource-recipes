#!/bin/sh

# priotirize useful packages by comparing with stuff installed

eix-installed all | sed -Ee 's/-[^-]*(-r[0-9]*)?$//' | while read foo; do
	if [ -d "$foo" ]; then
		continue
	fi
	CAT=${foo%/*}

	case $CAT in
		app-eselect)
			continue
			;;
		virtual)
			continue
			;;
		acct-*)
			continue
			;;
	esac

	echo "$foo"
done
