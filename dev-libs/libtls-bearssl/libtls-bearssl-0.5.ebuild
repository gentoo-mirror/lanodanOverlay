# Copyright 2024 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="libtls implemented with bearssl"
HOMEPAGE="https://sr.ht/~mcf/libtls-bearssl"
SRC_URI="https://git.sr.ht/~mcf/libtls-bearssl/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	dev-libs/bearssl:=
	!dev-libs/libretls
"
DEPEND="${RDEPEND}"

src_configure() {
	export PREFIX=/usr
	export LIBDIR="${EPREFIX}/usr/$(get_libdir)/"

	tc-export CC AR

	export CFLAGS="$CFLAGS $(pkg-config --cflags libbearssl)"
	export LDLIBS="$(pkg-config --libs libbearssl) -l pthread"

	sed -i 's;Libs.private: -lbearssl;Requires: libbearssl;' libtls.pc.in || die
}
