# Copyright 2023 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_SINGLE_IMPL=1
inherit distutils-r1

DESCRIPTION="Correcteur grammatical et typographique open source dédié à la langue française"
HOMEPAGE="https://grammalecte.net/"
SRC_URI="https://grammalecte.net/zip/Grammalecte-fr-v${PV}.zip"
S="${WORKDIR}/"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="$(python_gen_cond_dep 'dev-python/bottle[${PYTHON_USEDEP}]')"
DEPEND="${RDEPEND}"

src_prepare() {
	rm grammalecte/bottle.py || die
	sed -i -e 's;grammalecte.bottle;bottle;' grammalecte-server.py || die

	default
}
