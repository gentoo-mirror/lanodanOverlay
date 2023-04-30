# Copyright 2023 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit nodejs

DESCRIPTION="toolkit for rapidly building command line apps"
HOMEPAGE="https://github.com/node-js-libs/cli"
SRC_URI="https://github.com/node-js-libs/cli/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

# no tests
RESTRICT="test"

RDEPEND="
	dev-nodejs/glob
	dev-nodejs/exit
"

DOCS=( README.md examples )

src_install() {
	einstalldocs
	insinto "${NODEJS_SITELIB}${PN}"
	doins package.json
	doins index.js
	doins cli.js
}
