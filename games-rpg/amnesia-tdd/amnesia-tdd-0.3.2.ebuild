# Copyright 2023 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Amnesia: The Dark Descent"
HOMEPAGE="https://frictionalgames.com/ https://github.com/shamazmazum/AmnesiaTheDarkDescent"

EGIT_COMMIT="d3abfdd93bb650b12aa224ecc6f6aace42424189"
SRC_URI="https://github.com/shamazmazum/AmnesiaTheDarkDescent/archive/${EGIT_COMMIT}.tar.gz -> AmnesiaTheDarkDescent-${EGIT_COMMIT}.tar.gz"
S="${WORKDIR}/AmnesiaTheDarkDescent-${EGIT_COMMIT}"

# GPLv3+: amnesia-tdd
# zlib: AngelScript, Newton Dynamics and OALWrapper
LICENSE="GPL3+ ZLIB"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	media-libs/devil
	media-libs/glew:=
	media-libs/glu
	media-libs/libogg
	media-libs/libsdl2
	media-libs/libtheora
	media-libs/libvorbis
	media-libs/openal
	sys-libs/zlib
	virtual/opengl
"
RDEPEND="${DEPEND}"

CMAKE_USE_DIR="${S}/amnesia/src"

src_configure() {
	local mycmakeargs=(
		-DSYSTEMWIDE_RESOURCES=ON
		-DSYSTEMWIDE_RESOURCES_LOCATION="${EPREFIX}/usr/share/amnesia-tdd"
		-DOpenGL_GL_PREFERENCE=GLVND
	)

	cmake_src_configure
}
