# Copyright 2023 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="Free runtime and development kit using SDL and Squirrel"
HOMEPAGE="https://github.com/KelvinShadewing/brux-gdk"
EGIT_REPO_URI="https://github.com/lanodan/brux-gdk"
S="${WORKDIR}/${P}/rte"
LICENSE="AGPL-3.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-lang/squirrel
	media-libs/libsdl2
	media-libs/sdl2-image
	media-libs/sdl2-gfx
	media-libs/sdl2-mixer
	media-libs/sdl2-net
"
DEPEND="${RDEPEND}"

src_install() {
	einstalldocs
	dobin bin/brux
}
