# Copyright 2018 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="modular and portable cryptographic toolkit"
HOMEPAGE="https://www.libtom.net/LibTomCrypt/"
SRC_URI="https://github.com/libtom/libtomcrypt/releases/download/v${PV}/crypt-${PV}.tar.xz"

LICENSE="WTFPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc libtommath tomsfastmath"

RDEPEND="libtommath? ( dev-libs/libtommath )
	tomsfastmath? ( >=dev-libs/tomsfastmath-0.12 )
	!libtommath? ( !tomsfastmath? ( dev-libs/libtommath ) )"
DEPEND="${RDEPEND}
	doc? ( virtual/latex-base app-text/ghostscript-gpl )"

src_compile() {
	local extraflags=""
	use libtommath && append-flags "-DUSE_LTM -DLTM_DESC" && extraflags="-ltommath"
	use tomsfastmath && append-flags "-DUSE_TFM -DTFM_DESC" && extraflags="${extraflags} -ltfm"
	EXTRALIBS="${extraflags}" \
		CC=$(tc-getCC) \
		IGNORE_SPEED=1 \
		emake -f makefile.shared \
		|| die "emake failed"

	use doc && emake emake -f makefile.shared docs
}

src_install() {
	emake -f makefile.shared install PREFIX="/usr" DESTDIR="${D}" LIBPATH="/usr/$(get_libdir)"
	use doc && emake -f makefile.shared install_docs PREFIX="/usr" DESTDIR="${D}"
}
