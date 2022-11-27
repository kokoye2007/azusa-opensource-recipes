#!/bin/sh
source "../../common/init.sh"

MY_PV="${PV/0.}"
MY_PV="${MY_PV/./_}"

get http://www.bay12games.com/dwarves/df_${MY_PV}_linux.tar.bz2
acheck

# TODO we should be able to re-build libgraphics.so

rm df_linux/libs/{libgcc_s.so.1,libstdc++.so.6}
mkdir -p "${D}/pkg/main/${PKG}.core.${PVRF}/bin"
mv df_linux "${D}/pkg/main/${PKG}.data.${PVRF}"

# script inspired from the one used by archlinux
cat >"${D}/pkg/main/${PKG}.core.${PVRF}/bin/dwarf-fortress" <<EOF
#!/bin/bash
export SDL_DISABLE_LOCK_KEYS=1 # Work around for bug in Debian/Ubuntu SDL patch.
#export SDL_VIDEO_CENTERED=1    # Centre the screen.  Messes up resizing.

if [[ ! -d "\$HOME/.cache/dwarf-fortress" ]]; then
	mkdir -p "\$HOME/.cache/dwarf-fortress/data"
fi

# ln -snf overwrites symlinks
ln -snf "/pkg/main/${PKG}.data.${PVRF}/raw" "\$HOME/.cache/dwarf-fortress/raw"
ln -snf "/pkg/main/${PKG}.data.${PVRF}/libs" "\$HOME/.cache/dwarf-fortress/libs"
ln -snf "/pkg/main/${PKG}.data.${PVRF}/data/init" "\$HOME/.cache/dwarf-fortress/data/init"

for link in announcement art dipscript help index initial_movies movies shader.fs shader.vs sound speech; do
	cp -ru "/pkg/main/${PKG}.data.${PVRF}/data/\$link" -t "\$HOME/.cache/dwarf-fortress/data/"
done
cd "\$HOME/.cache/dwarf-fortress"
exec ./libs/Dwarf_Fortress "$@"
EOF
chmod +x "${D}/pkg/main/${PKG}.core.${PVRF}/bin/dwarf-fortress"

finalize
