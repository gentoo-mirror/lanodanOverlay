# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit mercurial cmake

DESCRIPTION="Simple Direct Media Layer"
HOMEPAGE="https://www.libsdl.org/"
EHG_REPO_URI="https://hg.libsdl.org/sdl12-compat"
S="${WORKDIR}/sdl12-compat"

LICENSE="ZLIB"
SLOT="0"

IUSE=""

src_prepare() {
	cmake_src_prepare

	sed -i \
		-e 's;PUBLIC "/usr/local/include/SDL2";PUBLIC "/usr/include/SDL2";' \
		-e 's;test_program(testsprite;#test_program(testsprite;' \
		CMakeLists.txt || die
}

src_install() {
	default

	dolib.so "${BUILD_DIR}/"libSDL-1.2.so*
}
