# Copyright 2023 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit nodejs

DESCRIPTION="Generates and consumes source maps"
HOMEPAGE="https://github.com/7rulnik/source-map-js"
SRC_URI="https://github.com/7rulnik/source-map-js/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

src_test() {
	node test/run-tests.js || die
}
