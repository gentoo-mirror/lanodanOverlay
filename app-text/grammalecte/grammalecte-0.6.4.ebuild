# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{4,5,6} )

inherit distutils-r1

DESCRIPTION="Grammatical corrector for the French language"
HOMEPAGE="https://dicollecte.org/"
SRC_URI="https://www.dicollecte.org/grammalecte/zip/Grammalecte-fr-v${PV}.zip"
RESTRICT="mirror"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="${PYTHON_DEPS}"
RDEPEND=""

S="${WORKDIR}"
