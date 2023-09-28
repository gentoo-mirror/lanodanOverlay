# Copyright 2023 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 cmake

DESCRIPTION="Open-source reimplementation of Sid Meier's Alpha Centauri (+ Alien Crossfire)"
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

CMAKE_BUILD_TYPE="Release"

src_prepare() {
	cmake_src_prepare

	# Should only be active for Windows but better be sure
	rm -r dependencies || die
}

src_install() {
	einstalldocs
	dobin "${BUILD_DIR}/bin/GLSMAC"
}

pkg_postinst() {
	einfo "You'll need to run GLSMAC in an unpacked version of Alpha Centauri, or point to it for example:"
	einfo " $ GLSMAC --smacpath ~/Games/GOG/sid_meiers_alpha_centauri/app/"
}
