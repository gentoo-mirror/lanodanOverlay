# Copyright 2020 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Universal configuration library parser"
HOMEPAGE="https://github.com/vstakhov/libucl"
SRC_URI="https://github.com/vstakhov/libucl/archive/0.8.1.tar.gz -> ${P}.tar.gz"
LICENSE="BSD-2"
SLOT="0/5.1.0"
KEYWORDS="~amd64"

IUSE="curl openssl libressl lua +static-libs utils"

DEPENDS="
	curl? ( net-misc/curl )
	openssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:= )
	)
	lua? ( dev-lang/lua:= )
"

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(use_enable curl urls) \
		$(use_enable openssl signatures) \
		$(use_enable lua) \
		$(use_enable utils)
}
