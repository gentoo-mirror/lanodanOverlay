# Copyright 2019 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

# vim-1.14 can also be found but the first version of vim to work on Unix
# is version 1.22, which I didn’t found.

EAPI=7

DESCRIPTION="Vi IMitation"
HOMEPAGE="https://www.vim.org/ https://ftp.nluug.nl/pub/vim/old/"
SRC_URI="https://ftp.nluug.nl/pub/vim/old/${P}.tar.gz"
SLOT="${PV}"
KEYWORDS="~x86 ~amd64"

S="${WORKDIR}/${P}/src"

src_prepare() {
	default

	ln makefile.unix makefile || die
	sed -r -i \
		-e 's/^(DEFS = .*) -DTERMCAP(.*)/\1\2/' \
		-e 's/^(DEFS = .*) -DSOME_BUILTIN_TCAPS(.*)/\1\2/' \
		-e 's/LIBS = -ltermlib/LIBS =/' \
		-e '165s;mkcmdtab;./mkcmdtab;' \
		makefile || die

	sed -i '28s/#ifdef SYSV/#ifndef SYSV/' unix.c
}

src_install() {
	cd ..
	newbin vim vim-${PV}
}

pkg_post_install() {
	einfo 'You will need to do have VIMINIT="" in your enviroment to prevent a segfault of vim'
}
