# Copyright 2020 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=(python2_7 python3_{6,7,8})

inherit distutils-r1

DESCRIPTION="CFFI binding for Hoedown, a markdown parsing library"
HOMEPAGE="http://pypi.python.org/pypi/misaka"
SRC_URI="https://github.com/FSX/misaka/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	>=app-text/hoedown-3
"
RDEPEND="${DEPEND}"
