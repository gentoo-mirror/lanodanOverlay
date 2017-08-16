# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit vim-plugin

DESCRIPTION="Next generation completion framework after neocomplcache"
HOMEPAGE="https://github.com/Shougo/neocomplete.vim"
SRC_URI="https://github.com/Shougo/neocomplete.vim/archive/ver.${PV}.tar.gz -> neocomplete-2.1.tar.gz"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86 ~arm"
IUSE=""

RDEPEND="app-editors/vim[lua]"

VIM_PLUGIN_HELPFILES="${PN}.txt"

src_unpack() {
	unpack ${A}
	mv ${PN}* "${S}"
}

src_prepare() {
	rm README* || die
	default
}

pkg_postinst() {
	elog "Execute :NeoCompleteEnable or add 'let g:neocomplete#enable_at_startup = 1' in your .vimrc"
}
