# Copyright 2024 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Dave Gilbert's Acorn Archimedes emulator"
HOMEPAGE="https://arcem.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/arcem-${PV}-src.zip"
S="${WORKDIR}/arcem-src"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="x11-libs/libX11"
RDEPEND="${DEPEND}"

src_prepare() {
	default

	# Clean out CFLAGS
	sed -i '/ifeq (\$(PROFILE),yes)/,/^$/d' Makefile || die
}

src_compile() {
	emake CC="$(tc-getCC)" LD="$(tc-getCC)"
}

src_install() {
	einstalldocs

	dobin arcem
}
