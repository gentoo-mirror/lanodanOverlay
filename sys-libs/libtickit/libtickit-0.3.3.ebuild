# Copyright 2020 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="library for building interactive full-screen terminal programs"
HOMEPAGE="http://www.leonerd.org.uk/code/libtickit/"
SRC_URI="http://www.leonerd.org.uk/code/${PN}/${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+unibilium"

DEPEND="
	dev-libs/libtermkey:=
	unibilium? ( >=dev-libs/unibilium-1.1.0:= )
	!unibilium? ( sys-libs/ncurses:= )
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-man_compression.patch" )

src_compile() {
	emake PREFIX=/usr
}

src_install() {
	emake PREFIX=/usr DESTDIR="${D}" LIBDIR="/usr/$(get_libdir)" install
	find "${ED}" -name '*.la' -delete || die
}
