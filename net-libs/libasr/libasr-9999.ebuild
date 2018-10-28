# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 autotools

DESCRIPTION="Async Resolver Library from OpenBSD/OpenSMTPD"
HOMEPAGE="https://github.com/OpenSMTPD/libasr"
SRC_URI=""

EGIT_REPO_URI="${HOMEPAGE}.git"

LICENSE="ISC BSD BSD-1 BSD-2 BSD-4"
SLOT="0"
KEYWORDS=""
IUSE="libressl"

RDEPEND="libressl? ( dev-libs/libressl:= )"
DEPEND="
	${RDEPEND}
"

src_prepare() {
	default
	eautoreconf
}
