# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 eutils

DESCRIPTION="A VSRG clone for playing .osu files."
HOMEPAGE="https://git.sakamoto.gq/eal/tinymania"

EGIT_REPO_URI="https://git.sakamoto.gq/eal/tinymania.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="media-libs/libsfml"
RDEPEND="${DEPEND}"

src_prepare() {
	default

	epatch "${FILESDIR}/tinymania-fix-Makefile.patch"
}

src_install() {
	emake install DESTDIR="${D}" PREFIX="/usr/games"
}
