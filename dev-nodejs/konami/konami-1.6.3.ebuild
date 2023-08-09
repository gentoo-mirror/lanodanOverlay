# Copyright 2022 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit nodejs

DESCRIPTION="An easter-egg script for adding the Konami Code to your website or project"
HOMEPAGE="https://github.com/georgemandis/konami-js"
SRC_URI="https://github.com/georgemandis/konami-js/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/konami-js-${PV}/"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

# Has no tests
RESTRICT="test"

src_install() {
	insinto "${NODEJS_SITELIB}${PN}"
	doins package.json
	doins konami.js
	dodoc README.md
}
