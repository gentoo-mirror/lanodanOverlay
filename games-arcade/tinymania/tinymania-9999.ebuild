# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 eutils

DESCRIPTION=""
HOMEPAGE=""

EGIT_REPO_URI="https://git.sakamoto.gq/eal/tinymania.git"

LICENSE=""
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
