# Copyright 2020 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="Open Sound System (OSS)"
HOMEPAGE="http://www.opensound.com/"
EGIT_REPO_URI="https://git.code.sf.net/p/opensound/git"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

DEPENDS="x11-libs/gtk+:2"
RDEPENDS="${DEPENDS}"

src_prepare() {
	default

	mkdir "${S}_build" || die "Failed creating empty build directory"
}

src_configure() {
	cd "${S}_build" || die "Failed changing to build directory"

	"${S}/configure" --enable-libsalsa=NO || die "Failed running ./configure"
}

src_compile() {
	cd "${S}_build" || die "Failed changing to build directory"

	emake build
}

src_install() {
	cd "${S}_build" || die "Failed changing to build directory"

	emake DESTDIR="${D}/" copy
}
