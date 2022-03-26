# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib

if [ "${PV}" = "9999" ]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/libsdl-org/sdl12-compat"
else
	SRC_URI="https://github.com/libsdl-org/sdl12-compat/archive/refs/tags/release-${PV}.tar.gz"
	S="${WORKDIR}/sdl12-compat-release-${PV}"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Simple Direct Media Layer (sdl-1.2 compatibility)"
HOMEPAGE="https://github.com/libsdl-org/sdl12-compat"
# dr_mp3: MIT-O or Unlicense
LICENSE="ZLIB || ( MIT-0 Unlicense )"
SLOT="0"
RESTRICT="!test? ( test )"

# First line are fakes and just there for compat with other ebuilds
IUSE="
	oss alsa nas X dga xv xinerama fbcon tslib aalib opengl libcaca +sound +video +joystick custom-cflags pulseaudio static-libs
	test
"

# IUSE inheritance dropped: dga, xv, fbcon, tflib, aalib, libcaca, custom-cflags, static-libs, X
DEPEND="
	media-libs/libsdl2[oss?,alsa?,nas?,xinerama?,opengl?,sound?,video?,joystick?,pulseaudio?]
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DSDL12TESTS=$(usex test)
	)

	cmake-multilib_src_configure
}
