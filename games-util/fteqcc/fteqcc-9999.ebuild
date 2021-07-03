# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit subversion edos2unix toolchain-funcs

DESCRIPTION="FTE QuakeC compiler"
HOMEPAGE="http://fteqw.sourceforge.net/"
ESVN_REPO_URI="https://svn.code.sf.net/p/fteqw/code/trunk"

LICENSE="GPL-2"
SLOT="0"
RESTRICT="test"

src_prepare() {
	default

	# Thanks subversion.eclass for targetting ${S} instead of ${WORKDIR}
	export S="${WORKDIR}/${P}/engine/qclib/"
	cd "${S}" || die

	edos2unix readme.txt
}

src_configure() {
	tc-export CC
}

src_install() {
	newbin fteqcc.bin fteqcc
	dodoc readme.txt
}
