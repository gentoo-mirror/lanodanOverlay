# Copyright 2021-2023 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="Collection of utilities inspired by Plan9"
HOMEPAGE="https://hacktivis.me/git/9utils"
EGIT_REPO_URI="https://hacktivis.me/git/9utils.git"
LICENSE="MPL-2.0"
SLOT="0"
IUSE="test"

RESTRICT="!test? ( test )"

RDEPEND="dev-lang/hare:="
DEPEND="${RDEPEND}"
BDEPEND="test? ( dev-util/cram )"

src_install() {
	PREFIX=/usr default
}
