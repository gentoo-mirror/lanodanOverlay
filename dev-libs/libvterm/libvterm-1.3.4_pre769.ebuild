# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit libtool flag-o-matic

# one-indexed: [1, 3, 4, pre, 769]
MY_PV="$(ver_cut 5)"

DESCRIPTION="An abstract library implementation of a VT220/xterm/ECMA-48 terminal emulator"
HOMEPAGE="http://www.leonerd.org.uk/code/libvterm/"
SRC_URI="https://bazaar.launchpad.net/~libvterm/libvterm/trunk/tarball/${MY_PV} -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	sys-devel/libtool
	virtual/pkgconfig
"

RDEPEND="!dev-libs/libvterm-neovim"

S="${WORKDIR}/~libvterm/libvterm/trunk/"

src_compile() {
	append-cflags -fPIC
	emake PREFIX="${EPREFIX}/usr" LIBDIR="${EPREFIX}/usr/$(get_libdir)"
}

src_install() {
	emake \
		PREFIX="${EPREFIX}/usr" \
		LIBDIR="${EPREFIX}/usr/$(get_libdir)" \
		DESTDIR="${D}" install

	find "${D}" -name '*.la' -delete
}
