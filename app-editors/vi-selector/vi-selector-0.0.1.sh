#!/bin/sh
source "../../common/init.sh"

acheck

mkdir -p "${D}/pkg/main/${PKG}.core.${PVRF}/bin"
cd "${D}/pkg/main/${PKG}.core.${PVRF}/bin" || exit

cat >vi <<EOF
#!/bin/sh
# ${P}

# This script will select the right version of vi to use based on the user's
# environment and run it.

if [ x"\$EDITOR_VI" != x ]; then
	exec "\$EDITOR_VI" "\$@"
fi

# fallback to vim
exec /pkg/main/app-editors.vim.core/bin/vim "\$@"
EOF

# make executable
chmod +x vi

archive
