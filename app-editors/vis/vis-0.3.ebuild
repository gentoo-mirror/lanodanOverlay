# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

# Package test version and name
MY_PTV=0.1
MY_PTN=${PN}-test
MY_PT=${MY_PTN}-${MY_PTV}

DESCRIPTION="modern, legacy free, simple yet efficient vim-like editor."
HOMEPAGE="https://github.com/martanne/vis"
SRC_URI="https://github.com/martanne/vis/archive/v${PV}.tar.gz -> ${P}.tar.gz
	test? ( https://github.com/martanne/vis-test/archive/v${MY_PTV}.tar.gz -> ${MY_PT}.tar.gz )"
LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="+ncurses lua lpeg selinux test tre"

#TODO: virtual/curses
DEPEND="dev-libs/libtermkey lua? ( >=dev-lang/lua-5.2:= ) tre? ( dev-libs/tre:= ) ncurses? ( sys-libs/ncurses:= ) app-eselect/eselect-vi"
RDEPEND="${DEPEND} lua? ( lpeg? ( >=dev-lua/lpeg-0.12 ) )"

src_prepare() {
	use test && (
		rm -r "${S}/test"
		mv "${WORKDIR}/${MY_PT}" "${S}/test"
		which vim &>/dev/null || sed -i 's/.*vim.*//' "${S}/test/Makefile"
	)
}

src_configure() {
	econf \
		$(use_enable lua) \
		$(use_enable ncurses curses) \
		$(use_enable selinux) \
		$(use_enable tre)
}

update_symlinks() {
	einfo "Calling eselect vi update --if-unset…"
	eselect vi update --if-unset
}

pkg_postrm() {
	update_symlinks
}

pkg_postinst() {
	update_symlinks
}
