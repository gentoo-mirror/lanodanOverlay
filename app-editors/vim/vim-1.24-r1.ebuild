# Copyright 2019-2023 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

# vim-1.14 can also be found but the first version of vim to work on Unix
# is version 1.22, which I didn’t found.

EAPI=8

DESCRIPTION="Vi IMitation"
HOMEPAGE="https://www.vim.org/ https://ftp.nluug.nl/pub/vim/old/"
SRC_URI="https://ftp.nluug.nl/pub/vim/old/${P}.tar.gz"
SLOT="${PV}"
KEYWORDS="~amd64 ~x86"
LICENSE="public-domain"

S="${WORKDIR}/${P}/src"

src_prepare() {
	default

	ln makefile.unix makefile || die
	sed -r -i \
		-e 's/CC=/CC ?=/' \
		-e 's/^(DEFS = .*) -DTERMCAP(.*)/\1\2/' \
		-e 's/^(DEFS = .*) -DSOME_BUILTIN_TCAPS(.*)/\1\2/' \
		-e 's/LIBS = -ltermlib/LIBS =/' \
		-e '165s;mkcmdtab;./mkcmdtab;' \
		makefile || die

	sed -i '28s/#ifdef SYSV/#ifndef SYSV/' unix.c || die

	# Make VIMINIT default to empty string, somehow this avoids a segfault
	sed -i '62asetenv("VIMINIT", "", 0);' main.c || die

	# musl doesn't have obsolete <termio.h> nor unsafe getwd
	sed -i \
		-e 's/termio.h/termios.h/' \
		-e 's/struct termio/struct termios/' \
		-e 's/getwd(buf)/getcwd(buf,len)/' \
		unix.c || die
}

src_install() {
	cd ..
	newbin vim vim-${PV}
}
