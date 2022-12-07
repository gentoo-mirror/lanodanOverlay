# Copyright 2022 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit nodejs

DESCRIPTION="2d canvas-based rapid prototyping game engine"
HOMEPAGE="https://github.com/andrewrk/chem"
SRC_URI="https://github.com/andrewrk/chem/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

# No testsuite
RESTRICT="test"

RDEPEND="
	>=dev-nodejs/vec2d-0.3.0
	>=dev-nodejs/pend-1.1.3
"
DEPEND="${RDEPEND}"

DOCS=( doc README.md )

src_install() {
	einstalldocs

	insinto "${NODEJS_SITELIB}${PN}"
	doins package.json
	doins index.js
	doins -r lib
}
