# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_4 python3_5 )
inherit distutils-r1

DESCRIPTION="Implementation of the PEP 3156 event-loop (asyncio) api using the Qt Event-Loop"
HOMEPAGE="https://github.com/harvimt/quamash"
SRC_URI="https://files.pythonhosted.org/packages/01/1e/cf6f3c38cee61ed04fea58667f673adc67d6412eba0b3327dbb5732c1177/Quamash-0.6.1.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/PyQt5"
RDEPEND="${DEPEND}"
