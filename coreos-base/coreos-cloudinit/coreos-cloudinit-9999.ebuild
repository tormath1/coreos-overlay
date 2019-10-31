# Copyright (c) 2014 CoreOS, Inc.. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_PROJECT="flatcar-linux/coreos-cloudinit"
CROS_WORKON_LOCALNAME="coreos-cloudinit"
CROS_WORKON_REPO="git://github.com"
COREOS_GO_PACKAGE="github.com/coreos/coreos-cloudinit"
inherit cros-workon systemd toolchain-funcs udev coreos-go

if [[ "${PV}" == 9999 ]]; then
	KEYWORDS="~amd64 ~arm64"
else
	CROS_WORKON_COMMIT="3f855bd1b7624fa6cb58d02bbaa2dc3f6bc43d53" # flatcar-master
	KEYWORDS="amd64 arm64"
fi

DESCRIPTION="coreos-cloudinit"
HOMEPAGE="https://github.com/coreos/coreos-cloudinit"
SRC_URI=""

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

DEPEND="!<coreos-base/coreos-init-0.0.1-r69"
RDEPEND="
	>=sys-apps/shadow-4.1.5.1
"

src_prepare() {
	coreos-go_src_prepare

	GOPATH+=":${S}/third_party"

	if gcc-specs-pie; then
		CGO_LDFLAGS+=" -fno-PIC"
	fi
}

src_compile() {
	export GO15VENDOREXPERIMENT="1"
	GO_LDFLAGS="-X main.version=$(git describe --dirty)" || die
	coreos-go_src_compile
}

src_install() {
	dobin ${GOBIN}/coreos-cloudinit
	udev_dorules units/*.rules
	systemd_dounit units/*.mount
	systemd_dounit units/*.path
	systemd_dounit units/*.service
	systemd_dounit units/*.target
	systemd_enable_service multi-user.target system-config.target
	systemd_enable_service multi-user.target user-config.target
}
