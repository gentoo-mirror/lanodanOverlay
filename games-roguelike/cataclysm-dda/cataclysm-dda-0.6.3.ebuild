# Copyright 2022 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV="$(ver_rs 2-3 -)"
MY_PV="${MY_PV/0.6/0.F}"
MY_P="Cataclysm-DDA-${MY_PV}"

DESCRIPTION="Post-apocalyptic roguelike"
HOMEPAGE="https://cataclysmdda.org/"
SRC_URI="https://github.com/CleverRaven/Cataclysm-DDA/archive/refs/tags/${MY_PV}.tar.gz -> ${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"
LICENSE="CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+sdl"

RDEPEND="
	x11-themes/hicolor-icon-theme
	sys-libs/ncurses:=
	sys-devel/gettext
	sdl? (
		media-libs/libsdl2[sound]
		media-libs/sdl2-image[png]
		media-libs/sdl2-ttf
		media-libs/sdl2-mixer[vorbis]
		media-libs/freetype:2
	)
"
DEPEND="
	${DEPEND}
"

mymake() {
	emake \
		PREFIX=/usr BUILD_PREFIX="${S}_build/" \
		RELEASE=1 USE_XDG_DIR=1 DYNAMIC_LINKING=1 DEBUG_SYMBOLS=1 ASTYLE=0 \
		BACKTRACE=0 RUNTESTS=0 \
		LOCALIZE=1 LANGUAGES=all \
		$(usev sdl 'TILES=1 SOUND=1') \
		"$@"
}

src_prepare() {
	sed -i \
		-e 's;-Werror;;' \
		-e 's;ncursesw5-config;ncursesw6-config;' \
		-e 's;shell git;shell false;' \
		Makefile || die

	default
}

src_compile() {
	mymake
}

src_install() {
	mymake DESTDIR="${ED}" install
	dodoc -r ./doc
}
