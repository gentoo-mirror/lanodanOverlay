# Copyright 2021-2023 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="Collection of extra tools for Unixes"
HOMEPAGE="https://hacktivis.me/git/utils-extra"
EGIT_REPO_URI="https://hacktivis.me/git/utils-extra.git"
LICENSE="MPL-2.0"
SLOT="0"
IUSE="test"

RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		dev-libs/atf
		dev-util/kyua
	)
"

src_configure() {
	export NO_BWRAP=1

	./configure PREFIX='/usr'
}

src_install() {
	emake install DESTDIR="${D}"
}
