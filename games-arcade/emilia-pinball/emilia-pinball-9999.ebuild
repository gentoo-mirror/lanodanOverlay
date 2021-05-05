# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ "${PV}" == "9999" ]]
then
	EGIT_REPO_URI="https://github.com/adoptware/pinball"
	inherit git-r3
else
	MY_P="pinball-${PV}"
	SRC_URI="https://github.com/rzr/pinball/archive/${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${MY_P}"
	KEYWORDS="~amd64 ~ppc ~sparc ~x86"
fi

DESCRIPTION="SDL OpenGL pinball game"
HOMEPAGE="https://github.com/adoptware/pinball"

LICENSE="GPL-2 CC0"
SLOT="0"
IUSE="gles1-only"

# Note: media-libs/libsdl2::gentoo doesn't have USE=gles1 yet
RDEPEND="
	media-libs/libsdl2[joystick,opengl,video]
	gles1-only? ( media-libs/libsdl2[gles1]↵ )
	virtual/opengl
"
DEPEND="
	${RDEPEND}
"

src_prepare() {
	default
	./bootstrap || die
}

src_configure() {
	econf $(use_enable gles1-only gles)
}
