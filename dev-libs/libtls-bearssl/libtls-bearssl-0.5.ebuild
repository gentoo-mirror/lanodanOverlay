# Copyright 2024-2025 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="libtls implemented with bearssl"
HOMEPAGE="https://sr.ht/~mcf/libtls-bearssl"
SRC_URI="https://git.sr.ht/~mcf/libtls-bearssl/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="ISC"
# See shlib_version
SLOT="0/20.3"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	>=dev-libs/bearssl-0.6_p20241009:=
	!dev-libs/libretls
"
DEPEND="${RDEPEND}"

src_configure() {
	export PREFIX=/usr
	export LIBDIR="${EPREFIX}/usr/$(get_libdir)/"

	tc-export CC AR

	export CFLAGS="$CFLAGS $(pkg-config --cflags bearssl)"
	export LDLIBS="$(pkg-config --libs bearssl) -l pthread"

	sed -i 's;Libs.private: -lbearssl;Requires: bearssl;' libtls.pc.in || die
}
