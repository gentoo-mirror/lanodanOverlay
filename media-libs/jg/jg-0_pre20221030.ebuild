# Copyright 2022 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Jolly Good API, an API for Emulators"
HOMEPAGE="https://gitlab.com/jgemu/jg"
EGIT_COMMIT="136dfb998b77d475baaa33370deb4f5f8a5d1503"
MY_P="${PN}-${EGIT_COMMIT}"
SRC_URI="https://gitlab.com/jgemu/jg/-/archive/${EGIT_COMMIT}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}/"
LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64"

src_configure() {
	export PREFIX=/usr
	export DOCDIR="/usr/share/doc/${P}/"
}
