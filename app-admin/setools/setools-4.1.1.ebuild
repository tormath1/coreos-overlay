# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
PYTHON_COMPAT=( python2_7 python3_6 python3_7 )

DISTUTILS_OPTIONAL=1
inherit distutils-r1

DESCRIPTION="Policy Analysis Tools for SELinux"
HOMEPAGE="https://github.com/SELinuxProject/setools/wiki"

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/SELinuxProject/setools.git"
else
	SRC_URI="https://github.com/SELinuxProject/setools/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 x86 arm64"
fi

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
IUSE="X debug test networkx python"

RDEPEND="
	python? ( ${PYTHON_DEPS} )
	>=sys-libs/libsepol-2.7:=
	>=sys-libs/libselinux-2.7:=[python?,${PYTHON_USEDEP}]
	networkx? ( >=dev-python/networkx-1.8[python?,${PYTHON_USEDEP}] )
	networkx? ( virtual/python-enum34[python?,${PYTHON_USEDEP}] )
	dev-libs/libpcre:=
	X? (
		dev-python/PyQt5[gui,widgets,python?,${PYTHON_USEDEP}]
	)"

DEPEND="${RDEPEND}
	>=dev-lang/swig-2.0.12:0
	sys-devel/bison
	sys-devel/flex
	>=sys-libs/libsepol-2.5
	test? (
		python_targets_python2_7? ( dev-python/mock[${PYTHON_USEDEP}] )
		dev-python/tox[${PYTHON_USEDEP}]
	)"

python_prepare_all() {
	sed -i "s/'-Werror', //" "${S}"/setup.py || die "failed to remove Werror"

	use X || epatch "${FILESDIR}"/setools-4.1.1-remove-gui.patch

	use networkx || sed -i "s@, 'sedta'@@g" "${S}"/setup.py || die "failed to remove sedta"
	use networkx || sed -i "s@, 'seinfoflow'@@g" "${S}"/setup.py || die "failed to remove seinfoflow"

	distutils-r1_python_prepare_all
}

python_test() {
	esetup.py test
}