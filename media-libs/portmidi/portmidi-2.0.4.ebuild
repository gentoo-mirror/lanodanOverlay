# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Library for real time MIDI input and output"
HOMEPAGE="http://portmedia.sourceforge.net/"
SRC_URI="https://github.com/PortMidi/portmidi/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc test-programs"

RDEPEND="media-libs/alsa-lib"
DEPEND="
	${RDEPEND}
	doc? ( app-doc/doxygen )
"

src_prepare() {
	cmake_src_prepare

	mkdir docs || die
	sed -i \
		-e 's;^OUTPUT_DIRECTORY\b.*;OUTPUT_DIRECTORY = docs;' \
		-e 's;^HTML_OUTPUT\b.*;HTML_OUTPUT = html;' \
		Doxyfile || die
}

src_configure() {
	#CMAKE_BUILD_TYPE=RelWithDebInfo

	local mycmakeargs=(
		-DBUILD_PORTMIDI_TESTS=$(usex test-programs)
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	if use doc; then doxygen || die; fi
}

src_install() {
	cmake_src_install
	use doc && dodoc -r docs/html
}
