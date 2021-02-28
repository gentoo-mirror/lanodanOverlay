# Copyright 1999-2021 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{4..9} )
inherit distutils-r1

DESCRIPTION="Parses, extracts, and builds 3DS firmware files"
HOMEPAGE="https://github.com/TuxSH/firmtool"
SRC_URI="https://github.com/TuxSH/firmtool/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/pycryptodome"
RDEPEND="${DEPEND}"
