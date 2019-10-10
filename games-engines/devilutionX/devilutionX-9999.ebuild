# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="Diablo build for modern operating systems"
HOMEPAGE="https://github.com/diasurgical/devilutionX"
if [[ "${PV}" == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/diasurgical/devilutionX.git"
else
	SRC_URI="https://github.com/diasurgical/devilutionX/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="Unlicense"
SLOT="0"

IUSE="debug"

RDEPEND="
	dev-libs/libsodium
	media-libs/libsdl2[haptic]
	media-libs/sdl2-mixer
	media-libs/sdl2-ttf
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
"

src_configure() {
	local mycmakeargs=(
		-DBINARY_RELEASE=ON
		-DDEBUG="$(usex debug)"
	)
	cmake-utils_src_configure
}

#src_install() {
#	dobin ${BUILD_DIR}/${PN}
#}

pkg_postinst() {
	einfo "In order to play the game you need to install the file"
	einfo "  diabdat.mpq"
	einfo "from the original game CD into the following directory:"
	einfo "  \${HOME}/.local/share/diasurgical/devilution/"
	einfo "and make sure it's writeable (chmod u+w)."
}
