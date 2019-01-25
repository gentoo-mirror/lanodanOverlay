# Copyright 2018 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=(python3_5 python3_6)

inherit distutils-r1

DESCRIPTION="Metadata Anonymisation Toolkit"
HOMEPAGE="https://0xacab.org/jvoisin/mat2"
LICENSE="LGPL-3"
SLOT="0"
SRC_URI="https://0xacab.org/jvoisin/mat2/uploads/e958dde527c7255e94ae2b347086ba9f/mat-0.6.0.tar.xz"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	media-libs/mutagen:*
	dev-python/pygobject:3
	dev-python/pycairo:*
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/mat-${PV}"
