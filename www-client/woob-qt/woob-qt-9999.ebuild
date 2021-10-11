# Copyright 2021 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

if [[ "${PV}" == "9999" ]]
then
	EGIT_REPO_URI="https://gitlab.com/woob/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://gitlab.com/woob/${PN}/-/archive/${PV}/${P}.tar.gz"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Web outside of Browsers (Qt applications)"
HOMEPAGE="https://gitlab.com/woob/woob-qt"
LICENSE="LGPL-3+"
SLOT="0"

DEPEND="
	app-crypt/gnupg
	dev-python/PyQt5[${PYTHON_USEDEP},multimedia]
	dev-libs/libyaml
	dev-python/simplejson[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"
