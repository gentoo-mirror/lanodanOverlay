# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit multilib toolchain-funcs eutils

DESCRIPTION="A program (and preload library) to fake system date"
HOMEPAGE="http://packages.qa.debian.org/d/datefudge.html"
SRC_URI="mirror://debian/pool/main/d/${PN}/${PN}_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE=""

src_prepare() {
	use userland_BSD && epatch "${FILESDIR}"/${P}-bsd.patch
	epatch "${FILESDIR}/datefudge-alt-libc.patch"
	sed -i \
		-e '/dpkg-parsechangelog/d' \
		-e "s:usr/lib:usr/$(get_libdir):" \
		Makefile || die

	if use prefix; then
		sed -i -e '/-o root -g root/d' Makefile || die
	fi
	eapply_user
}

src_compile() {
	emake CC="$(tc-getCC)" VERSION="${PV}"
}

src_install() {
	emake DESTDIR="${ED}" VERSION="${PV}" install
	dodoc debian/changelog README
}
