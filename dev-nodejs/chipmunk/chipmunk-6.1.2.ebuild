# Copyright 2023 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit nodejs

DESCRIPTION="Port of slembcke/Chipmunk-Physics to Javascript"
HOMEPAGE="https://github.com/josephg/Chipmunk-js"
SRC_URI="https://github.com/josephg/Chipmunk-js/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/Chipmunk-js-${PV}"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="dev-util/uglifyjs"

# no testsuite
RESTRICT="test"

src_prepare() {
	default
	emake clean
}

src_compile() {
	emake
}
