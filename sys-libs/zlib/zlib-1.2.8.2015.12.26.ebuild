# Copyright 2020 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Standard (de)compression library (Sortix's libz fork)"
HOMEPAGE="https://sortix.org/libz/"
SRC_URI="https://sortix.org/libz/release/libz-${PV}.tar.gz"
LICENSE="ZLIB"
SLOT="0/1"
KEYWORDS="~amd64"

RDEPEND="!sys-libs/zlib:0"

S="${WORKDIR}/libz-${PV}"
