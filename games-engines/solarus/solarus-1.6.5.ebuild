# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-1 luajit )

inherit cmake lua-single virtualx

DESCRIPTION="An open-source Zelda-like 2D game engine"
HOMEPAGE="https://www.solarus-games.org/"
SRC_URI="https://gitlab.com/solarus-games/solarus/-/archive/v${PV}/solarus-v${PV}.tar.gz"
S="${WORKDIR}/${PN}-v${PV}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc qt5 test"
RESTRICT="!test? ( test )"

RDEPEND="
	${LUA_DEPS}
	dev-games/physfs
	media-libs/glm
	media-libs/libmodplug
	media-libs/libsdl2[X,joystick,video]
	media-libs/libvorbis
	media-libs/openal
	media-libs/opengl
	media-libs/sdl2-image[png]
	media-libs/sdl2-ttf
	qt5? ( dev-qt/qtgui:5 )
"
DEPEND="
	${RDEPEND}
	doc? ( app-doc/doxygen )
"

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DSOLARUS_USE_LUAJIT="$(usex lua_single_target_luajit)"
		-DSOLARUS_GUI="$(usex qt5)"
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	if use doc ; then
		cd doc || die
		doxygen || die
	fi
}

src_test() {
	virtx cmake_src_test
}

src_install() {
	cmake_src_install
	use doc && dodoc -r doc/${PV%.*}/html/*
}
