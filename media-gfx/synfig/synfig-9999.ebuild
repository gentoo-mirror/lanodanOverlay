# Copyright 2022 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 cmake

DESCRIPTION="Open-source 2D Animation Software"
HOMEPAGE="https://www.synfig.org/"
EGIT_REPO_URI="https://github.com/synfig/synfig/"
LICENSE="GPL-2+ GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="imagemagick jack"

RDEPEND="
	dev-cpp/glibmm:2=
	dev-cpp/gtkmm:3.0=
	dev-cpp/libxmlpp:2.6=
	dev-libs/boost:=
	dev-libs/fribidi:=
	dev-libs/libsigc++:2=
	media-libs/fontconfig:=
	media-libs/freetype:2=
	media-libs/harfbuzz:=
	media-libs/libjpeg-turbo:=
	media-libs/libpng:=
	media-libs/mlt:=
	media-libs/openexr:=
	media-libs/sdl2-mixer:=
	sci-libs/fftw:3.0=
	sys-libs/zlib:=
	x11-libs/pango:=
	imagemagick? ( media-gfx/imagemagick:=[cxx] )
	jack? ( virtual/jack:= )
"
DEPEND="
	${RDEPEND}
	sys-devel/gettext:=
	dev-util/intltool:=
"

src_prepare() {
	cmake_src_prepare

	sed -i ';DESTINATION lib;;' synfig-studio/src/synfigapp/CMakeLists.txt || die
	sed -i ';DESTINATION lib;;' synfig-core/src/synfig/CMakeLists.txt || die
}
