#!/bin/sh

echo -n "Provide file url: "
read file

base=`basename "$file" .tar.gz`
pkg=`echo "$base" | sed -r -e 's/(.*)-.*/\1/'`
URL_REPL=`echo "$file" | sed -e "s/${base}/\\\${P}/"`

if [ -f "$pkg/$base.sh" ]; then
	echo "File exists, build with:"
	ROOTDIR=`realpath ..`
	echo "$ROOTDIR/common/build.sh dev-perl/$pkg/$base.sh"
	exit
fi

echo "Creating: dev-perl/$pkg/$base.sh"

# make dir if needed
if [ ! -d "$pkg" ]; then
	mkdir "$pkg"
fi

cat >"$pkg/$base.sh" <<EOF
#!/bin/sh
source "../../common/init.sh"
inherit perl

get $URL_REPL
acheck

cd "\${P}"

perlsetup
finalize
EOF

chmod +x "$pkg/$base.sh"

# cause download now
cd $pkg
./$base.sh

