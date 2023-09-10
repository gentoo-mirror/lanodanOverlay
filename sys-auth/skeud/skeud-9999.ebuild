# Copyright 2021-2023 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="Simple and portable utilities to deal with user accounts (su, login)"
HOMEPAGE="https://hacktivis.me/git/skeud"
EGIT_REPO_URI="https://hacktivis.me/git/skeud.git"
LICENSE="MPL-2.0"
SLOT="0"
IUSE="test"

RESTRICT="!test? ( test )"

RDEPEND="virtual/libcrypt"
DEPEND="${RDEPEND}"
BDEPEND="
	test? (
		dev-libs/atf
		dev-util/kyua
	)
"

src_install() {
	emake install DESTDIR="${D}" PREFIX='/usr'
}
