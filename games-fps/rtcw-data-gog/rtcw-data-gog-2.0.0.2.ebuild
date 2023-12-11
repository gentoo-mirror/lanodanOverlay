# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
DESCRIPTION="Data files for Return To Castle Wolfenstein (RTCW) from gog.com"
HOMEPAGE="https://www.gog.com/game/return_to_castle_wolfenstein"
SRC_URI="setup_return_to_castle_wolfenstein_${PV}.exe"
LICENSE="GOG-EULA"
SLOT="0"
KEYWORDS="~amd64 ~arm ~m68k ~x86"
RESTRICT="bindist fetch"

BDEPEND="app-arch/innoextract"

S="${WORKDIR}"

pkg_nofetch() {
	einfo "Please buy and download ${SRC_URI} from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move it to your distfiles directory."
}

src_install() {
	innoextract --extract --lowercase \
		--include=/app/Main \
		"${DISTDIR}/${A}" || die

	insinto /usr/share/wolf
	doins app/main/*.pk3
}
