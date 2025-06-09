# Copyright 2023 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1
inherit distutils-r1

DESCRIPTION="Python IP address to Autonomous System Number lookup module"
HOMEPAGE="https://github.com/hadiasghari/pyasn"
SRC_URI="https://github.com/hadiasghari/pyasn/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT ISC BSD-4"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

distutils_enable_tests pytest

python_test() {
	rm -fr pyasn || die
	epytest
}
