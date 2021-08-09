#!/bin/bash

for foo in */*; do
	if [ ! -d "$foo" ]; then
		continue
	fi

	# check if this exists
	p="/pkg/main/${foo/\//.}"

	if [ -L "$p" ]; then
		continue
	fi
	if [ -L "$p.core" ]; then
		continue
	fi
	if [ -L "$p.libs" ]; then
		continue
	fi
	if [ -L "$p.fonts" ]; then
		continue
	fi
	echo "not found: $foo"
done
