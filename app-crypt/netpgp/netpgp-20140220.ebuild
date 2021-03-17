# Copyright 2019 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="OpenPGP implementation from NetBSD"
HOMEPAGE="http://netpgp.com/"
LICENSE="ISC"
SRC_URI="http://netpgp.com/src/${P}.tar.gz"
SLOT="0"
KEYWORDS="~amd64"

# OpenSSL 0.9.8 or newer
# TODO: bzlib ?
DEPEND="
	dev-libs/openssl:=
	sys-libs/zlib
"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i 's/WARNCFLAGS="-Werror /WARNCFLAGS="/' configure || die

	default
}
