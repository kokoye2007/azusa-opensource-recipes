#!/bin/sh
source "../../common/init.sh"

git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
S="${CHPATH}/depot_tools"
acheck

cd "${S}"

# grab last commit date/time as version (YYYYMMDD.HHMMSS)
DEPOT_VER=`git log -1 --format=%at | xargs -I{} date -d @{} +%Y%m%d.%H%M%S`

TARGET="/pkg/main/${PKG}.core.${PVR}.${DEPOT_VER}.${OS}.${ARCH}"
mkdir -pv "${D}$TARGET"

cd "$T"

mv -vT "$S" "${D}$TARGET/depot_tools"
cd "${D}$TARGET/depot_tools"

# remove useless git stuff
rm -fr .git .gitattributes .gitignore

# disable auto updates
touch .disable_auto_update

mkdir -pv "${D}$TARGET/bin"
cd "${D}$TARGET/bin"

# note: depot_tools depend on itself being in path, so we provide it in the wrapper
cat >gclient <<EOF
#!/bin/sh
CMD=\`basename "\$0"\`
export PATH="\$PATH:$TARGET/depot_tools"
exec "$TARGET/depot_tools/\$CMD" "$@"
EOF

chmod +x gclient

# list of depot_tools commands we expose (we do not want to expose stuff like ninja that we already provide)
for foo in fetch ../depot_tools/git-* ; do
	ln -snfTv gclient `basename "$foo"`
done

finalize
