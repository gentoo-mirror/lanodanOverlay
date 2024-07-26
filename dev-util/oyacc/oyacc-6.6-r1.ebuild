# Copyright 2024 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Portable OpenBSD Yacc"
HOMEPAGE="https://github.com/ibara/yacc"
SRC_URI="https://github.com/ibara/yacc/archive/refs/tags/oyacc-${PV}.tar.gz"
S="${WORKDIR}/yacc-oyacc-${PV}/"
LICENSE="BSD ISC public-domain"
SLOT="0"
KEYWORDS="~amd64"
IUSE="static"

src_configure() {
	# Somehow BINDIR isn't set in the generated Makefile
	export BINDIR="${EPREFIX}/usr/bin"

	# --disable-yacc: Installs as oyacc+oyyfix rather than yacc+yyfix
	./configure \
		--prefix="${EPREFIX}/usr" \
		--mandir="${EPREFIX}/usr/share/man/man1" \
		--disable-yacc \
		$(use_enable static) \
		|| die
}
