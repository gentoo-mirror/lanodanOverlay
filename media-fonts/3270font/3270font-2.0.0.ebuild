# Copyright 2018-2019 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit font

DESCRIPTION="A IBM 3270 Terminal font in a modern format"
HOMEPAGE="https://github.com/rbanffy/3270font/"
SRC_URI="https://github.com/rbanffy/3270font/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD CC-BY-SA-3.0 GPL-3 OFL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="
	${DEPEND}
	media-gfx/fontforge
"

FONT_S="${S}/build"
FONT_SUFFIX="otf ttf pfm woff"
