# Copyright 2018-2019 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit font

DESCRIPTION="Opensource font for dyslexics and for high readability"
SRC_URI="https://github.com/antijingoist/open-dyslexic/archive/${PV}-Stable.tar.gz -> ${P}.tar.gz"
LICENSE="BitstreamVera"
SLOT="0"

FONT_SUFFIX="ttf otf"
