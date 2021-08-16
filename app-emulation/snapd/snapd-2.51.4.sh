#!/bin/sh
source "../../common/init.sh"

get https://github.com/snapcore/${PN}/releases/download/${PV}/${PN}_${PV}.vendor.tar.xz
acheck

MAKEOPTS=(
	BINDIR=/pkg/main/${PKG}.core.${PVRF}/bin
	#DBUSSERVICESDIR=/usr/share/dbus-1/services
	LIBEXECDIR=/pkg/main/${PKG}.libs.${PVRF}/libexec
	SNAP_MOUNT_DIR=/var/lib/snapd/snap
	#SYSTEMDSYSTEMUNITDIR=
)

cd "${S}"
sed -i 's:command -v git >/dev/null:false:' mkversion.sh
./mkversion.sh "${PV}"

cd "${S}/cmd"
export CGO_ENABLED="1"
export CGO_CFLAGS="${CFLAGS}"
export CGO_CPPFLAGS="${CPPFLAGS}"
export CGO_CXXFLAGS="${CXXFLAGS}"
export GO111MODULE=off GOBIN="${S}/bin" GOPATH="${S}"

doconf --enable-apparmor --enable-nvidia-biarch --with-snap-mount-dir=/var/lib/snapd/snap

for file in "${S}/po/"*.po; do
	msgfmt "${file}" -o "${file%.po}.mo"
done

make -C "${S}/data" "${MAKEOPTS[@]}"

local -a flags=(-buildmode=pie -ldflags "-s -linkmode external -extldflags '${LDFLAGS}'" -trimpath)
local -a staticflags=(-buildmode=pie -ldflags "-s -linkmode external -extldflags '${LDFLAGS} -static'" -trimpath)

local cmd
for cmd in snap snapd snap-bootstrap snap-failure snap-preseed snap-recovery-chooser snap-repair snap-seccomp; do
	go build -o "${GOBIN}/${cmd}" "${flags[@]}" -v -x "github.com/snapcore/${PN}/cmd/${cmd}"
	[[ -e "${GOBIN}/${cmd}" ]] || die "failed to build ${cmd}"
done
for cmd in snapctl snap-exec snap-update-ns; do
	go build -o "${GOBIN}/${cmd}" "${staticflags[@]}" -v -x "github.com/snapcore/${PN}/cmd/${cmd}"
	[[ -e "${GOBIN}/${cmd}" ]] || die "failed to build ${cmd}"
done

make -C "${S}/data" install "${SNAPD_MAKEARGS[@]}" DESTDIR="${D}"
make -C "${S}/cmd" install "${SNAPD_MAKEARGS[@]}" DESTDIR="${D}"

mkdir -p "${D}/pkg/main/${PKG}.libs.${PVRF}/libexec"
cp -v -t "${D}/pkg/main/${PKG}.libs.${PVRF}/libexec" \
	"${GOBIN}/"{snapd,snap-bootstrap,snap-failure,snap-exec,snap-preseed,snap-recovery-chooser,snap-repair,snap-seccomp,snap-update-ns} \
	"${S}/"{cmd/snap-confine/snap-device-helper,cmd/snap-discard-ns/snap-discard-ns,cmd/snap-gdb-shim/snap-gdb-shim,cmd/snap-mgmt/snap-mgmt} \
	"${S}/data/completion/bash/"{complete.sh,etelpmoc.sh,}

mkdir -p "${D}/pkg/main/${PKG}.core.${PVRF}/share/polkit-1/actions"
cp -v -t "${D}/pkg/main/${PKG}.core.${PVRF}/share/polkit-1/actions" \
	"${S}/data/polkit/io.snapcraft.snapd.policy"

finalize
