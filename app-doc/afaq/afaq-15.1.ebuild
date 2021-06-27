# Copyright 2019 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="An Anarchist FAQ, scrapped in one collection and a markdown version"
HOMEPAGE="https://0xacab.org/ju/afaq https://anarchism.pageabode.com/afaq/index.html"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390  ~sparc ~x86  "
SRC_URI="https://0xacab.org/ju/afaq/-/archive/${PV}/${P}.tar.gz"

src_install() {
	dodoc -r html markdown README.md
}
