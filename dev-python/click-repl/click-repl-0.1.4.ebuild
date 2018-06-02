# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )

inherit distutils-r1

DESCRIPTION="Subcommand REPL for click apps"
HOMEPAGE="https://github.com/click-contrib/click-repl https://pypi.python.org/pypi/click-repl"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/click[${PYTHON_USEDEP}]
	dev-python/prompt_toolkit[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

DOCS=( README.rst )
