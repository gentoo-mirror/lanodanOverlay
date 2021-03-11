# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit git-r3 cmake

DESCRIPTION="Simple Direct Media Layer (sdl-1.2 compatibility)"
HOMEPAGE="https://github.com/libsdl-org/sdl12-compat"

# Used for .pc and ./include/
# See https://github.com/libsdl-org/sdl12-compat/issues/34
SRC_URI="https://libsdl.org/release/SDL-1.2.15.tar.gz"

EGIT_REPO_URI="https://github.com/libsdl-org/sdl12-compat"
LICENSE="ZLIB"
SLOT="0"

# Those are fakes and just there for compat with other ebuilds
IUSE="oss alsa nas X dga xv xinerama fbcon tslib aalib opengl libcaca +sound +video +joystick custom-cflags pulseaudio static-libs"

src_unpack() {
	default
	git-r3_src_unpack
}

src_prepare() {
	cmake_src_prepare

	mv "${WORKDIR}/SDL-1.2.15/include" "${WORKDIR}/SDL" || die

	sed -i \
		-e 's;test_program(testsprite;#test_program(testsprite;' \
		CMakeLists.txt || die
}

src_install() {
	default

	dolib.so "${BUILD_DIR}/"libSDL-1.2.so*

	doheader -r "${WORKDIR}/SDL"

	mkdir -p "${ED}/usr/lib/pkgconfig"

	sed \
		-e "s;@prefix@;${EROOT}/usr;" \
		"${FILESDIR}/sdl.pc.in" > "${ED}/usr/lib/pkgconfig/sdl.pc" || die
}
