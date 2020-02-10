# Copyright 2020 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A colorized hexdump tool"
HOMEPAGE="http://www.muppetlabs.com/~breadbox/software/xcd.html"
SRC_URI="http://www.muppetlabs.com/~breadbox/pub/software/${P}.tar.gz"
LICENSE=""
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sh ~sparc ~x86"

DEPEND="sys-libs/ncurses:="
RDEPEND="${DEPEND}"

src_install() {
	dobin xcd
}
