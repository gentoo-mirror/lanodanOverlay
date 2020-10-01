# Copyright 2016-2019 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="static git page generator"
HOMEPAGE="https://git.codemadness.org/stagit/"
SRC_URI="https://codemadness.org/releases/stagit/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-libs/libgit2:="
RDEPEND="${DEPEND}"

src_configure() {
	sed -i \
		-e "/^.POSIX:/d" \
		-e "s;^PREFIX =.*;PREFIX ?= ${EPREFIX}/usr;" \
		-e "s;^MANPREFIX = .*;MANPREFIX = ${EPREFIX}/usr/share/man;" \
		"${S}/Makefile" || die
}
