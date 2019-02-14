# Copyright 2018 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit font

REPO_PN="Fork-Awesome"

DESCRIPTION="The iconic font"
HOMEPAGE="http://fontawesome.io"
SRC_URI="https://github.com/ForkAwesome/${REPO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="CC-BY-3.0 OFL-1.1" # MIT for CSS/LESS files?
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${REPO_PN}-${PV}"

FONT_S="${S}/fonts"
FONT_SUFFIX="ttf woff2"
