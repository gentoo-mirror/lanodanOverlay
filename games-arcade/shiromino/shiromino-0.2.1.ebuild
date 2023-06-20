# Copyright 2023 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="fast-paced puzzle game with roots in the arcade"
HOMEPAGE="https://github.com/shiromino/shiromino"
SRC_URI="https://github.com/shiromino/shiromino/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT CC-BY-4.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

BDEPEND="virtual/pkgconfig"

RDEPEND="
	media-libs/libvorbis
	media-libs/libsdl2
	media-libs/sdl2-image
	media-libs/sdl2-mixer
	dev-db/sqlite:3
"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}/shiromino-0.2.1-fix_cmake_targets.patch" )

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_SYSCONFDIR="${EPREFIX}/etc"
		# -DFETCHCONTENT_FULLY_DISCONNECTED=ON
	)

	cmake_src_configure
}
