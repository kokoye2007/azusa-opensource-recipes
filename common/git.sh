#!/bin/bash

fetchgit() {
	# fetchgit repository tag
	local gitbase
	gitbase="$(basename $1)"
	gitbase="${gitbase/.git}"
	local tag
	tag="$2"
	local BN
	BN="${gitbase}-${tag}.tar.xz"

	# try to get from our system
	wget --ca-certificate=/etc/ssl/certs/ca-certificates.crt -O "$BN" "$(echo "https://pkg.azusa.jp/src/main/${CATEGORY}/${PN}/${BN}" | sed -e 's/+/%2B/g')" || true
	if [ -s "$BN" ]; then
		extract "$BN"
		# owner might differ, add directory to safe.directory
		git config --global --add safe.directory "${S}"
		return
	fi

	# failed download, get file, then upload...
	echo "Downloading from git: $1"
	git clone --no-checkout --quiet "$1" "${gitbase}-${tag}"
	cd "${gitbase}-${tag}"
	S="${PWD}"
	echo "Checking out tag $tag ..."
	git checkout --quiet --detach "$tag"
	git submodule update --init
	cd ..

	if [ -f "$HOME/.aws/credentials" ]; then
		echo "Archiving for upload..."
		# include also .git repo so we archive the whole history
		tar cJf "$BN" "${gitbase}-${tag}"
		# upload if possible to aws
		aws s3 cp "$BN" "s3://azusa-pkg/src/main/${PKG/.//}/${BN}"
	fi
}
