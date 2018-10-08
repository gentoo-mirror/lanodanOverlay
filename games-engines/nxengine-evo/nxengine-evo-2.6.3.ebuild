# Copyright 2018 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="rewrite of the jump-and-run platformer Doukutsu Monogatari(Cave Story)"
HOMEPAGE="https://github.com/nxengine/nxengine-evo http://nxengine.sourceforge.net/"
SRC_URI="https://github.com/nxengine/nxengine-evo/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SLOT="evo"
LICENSE="GPL-3"
KEYWORDS="~amd64"

DEPENDS="
	media-libs/libpng:=
	media-libs/libsdl2:=
	media-libs/sdl2-mixer:=
	media-libs/sdl2-ttf:=
"

src_install() {
	newbin bin/extract nx-extract
	dobin bin/nx
}
