# Copyright 1999-2015 Gentoo Foundation
# Copyright 2019 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit python-any-r1 scons-utils

MY_P="${PN}-$(ver_rs 1-2 -)"

if [ "${PV}" == "9999" ]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/VDrift/vdrift"
else
	SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A driving simulation made with drift racing in mind"
HOMEPAGE="http://vdrift.net/"
LICENSE="GPL-3 ZLIB LGPL-2.1+"
SLOT="0"

S="${WORKDIR}/${PN}"

RDEPEND="
	media-libs/libsdl2[opengl,video]
	media-libs/sdl2-image[png]
	media-libs/libvorbis
	net-misc/curl
	sci-physics/bullet[-double-precision]
	"
DEPEND="${RDEPEND}"

src_configure() {
	MYSCONS=(
		destdir="${D}"
		prefix=/usr
		release=1
		os_cc=1
		os_cxx=1
		os_cxxflags=1
		force_feedback=1
	)
}

src_compile() {
	escons "${MYSCONS[@]}"
}

src_install() {
	escons "${MYSCONS[@]}" DESTDIR="${D}" install
	default
}
