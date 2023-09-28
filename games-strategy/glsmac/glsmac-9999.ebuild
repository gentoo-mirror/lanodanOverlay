# Copyright 2023 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 cmake

DESCRIPTION="Unofficial open-source OpenGL/SDL2 reimplementation of Sid Meier's Alpha Centauri (+Alien Crossfire)"
HOMEPAGE="https://github.com/afwbkbc/glsmac"
EGIT_REPO_URI="https://github.com/afwbkbc/glsmac"
LICENSE="AGPL-3"
SLOT="0"

RDEPEND="
	media-libs/libsdl2
	media-libs/sdl2-image
	media-libs/freetype
	media-libs/glew
"
DEPEND="${RDEPEND}"

src_prepare() {
	default

	# Should only be active for Windows but better be sure
	rm -r dependencies || die
}

pkg_postinst() {
	einfo "You'll need to point GLSMAC to an unpacked version of Alpha Centauri, for example:"
	einfo " $ GLSMAC --smacpath ~/Games/GOG/sid_meiers_alpha_centauri/app/"
}
