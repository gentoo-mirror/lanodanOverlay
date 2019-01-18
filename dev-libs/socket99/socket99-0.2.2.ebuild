# Copyright 2019 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Wrapper library for the BSD sockets API with a nicer C99 interface"
HOMEPAGE="https://github.com/silentbicycle/socket99"
SRC_URI="https://github.com/silentbicycle/socket99/archive/v0.2.2.tar.gz -> ${P}.tar.gz"
LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"

src_compile() {
	emake "lib${PN}.a"
}

src_install() {
	dolib.a "lib${PN}.a"
	doheader "${PN}.h"
}
