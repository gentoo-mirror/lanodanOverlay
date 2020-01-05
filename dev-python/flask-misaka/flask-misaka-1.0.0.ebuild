# Copyright 2020 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=(python2_7 python3_{6,7,8})

inherit distutils-r1

DESCRIPTION="Flask interface to Misaka, a markdown parsing library"
HOMEPAGE="http://pypi.python.org/pypi/Flask-Misaka"
SRC_URI="https://github.com/singingwolfboy/flask-misaka/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	>=dev-python/flask-0.7
	>=dev-python/misaka-2.0
"
RDEPEND="${DEPEND}"
