# Copyright 2018 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs flag-o-matic

DESCRIPTION="modular and portable cryptographic toolkit"
HOMEPAGE="https://www.libtom.net/LibTomCrypt/"
SRC_URI="https://github.com/libtom/libtomcrypt/releases/download/v${PV}/crypt-${PV}.tar.xz"

LICENSE="WTFPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"

RDEPEND="dev-libs/libtommath"
DEPEND="${RDEPEND}
	doc? ( virtual/latex-base app-text/ghostscript-gpl )"

src_compile() {
	append-flags "-DUSE_LTM -DLTM_DESC"

	EXTRALIBS="-ltommath" \
	CC=$(tc-getCC) \
	IGNORE_SPEED=1 \
		emake -f makefile.shared || die "emake failed"

	use doc && emake emake -f makefile.shared docs
}

src_install() {
	emake -f makefile.shared install PREFIX="/usr" DESTDIR="${D}" LIBPATH="/usr/$(get_libdir)"
	use doc && emake -f makefile.shared install_docs PREFIX="/usr" DESTDIR="${D}"
}
