# Copyright 2024 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs edo

DESCRIPTION="HTTP 1.1 webserver, serving static files and CGI/NPH"
HOMEPAGE="https://www.skarnet.org/software/tipidee/"
SRC_URI="https://www.skarnet.org/software/tipidee/${P}.tar.gz"
LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"
IUSE="static"

DEPEND=">=dev-libs/skalibs-2.14.1.1"
RDEPEND="${DEPEND}"

DOCS=( doc examples )

src_prepare() {
	default

	sed -i -e '/AR := /d' -e '/RANLIB := /d' Makefile || die
}

src_configure() {
	tc-export AR CC RANLIB

	edo ./configure \
		${CTARGET:+--target=${CTARGET}} \
		--host="${CHOST}" \
		--prefix="${EPREFIX}"/usr \
		--sysconfdir="${EPREFIX}"/etc \
		--with-sysdeps="/usr/$(get_libdir)/skalibs" \
		--disable-static \
		$(use_enable static static-libc)
}
