# Copyright 2019 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="Clone of the Touhou series, written in C using SDL/OpenGL/OpenAL."
HOMEPAGE="http://taisei-project.org/"
LICENSE="BSD"
SLOT="0"
SRC_URI="https://github.com/taisei-project/taisei/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"
IUSE="webp libzip"

DEPEND="
	media-libs/freetype:2
	>=media-libs/libpng-1.5
	media-libs/libsdl2
	media-libs/sdl2-mixer
	webp? ( media-libs/libwebp )
	libzip? ( dev-libs/libzip )
	sys-libs/zlib
"

src_prepare() {
	sed -i '/strip=true/d' meson.build || die "Failed removing auto-stripping"
	default
}
