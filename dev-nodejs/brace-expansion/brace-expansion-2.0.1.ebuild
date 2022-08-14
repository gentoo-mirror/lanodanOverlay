# Copyright 2022 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit nodejs

DESCRIPTION="Brace expansion, as known from sh/bash, in JavaScript"
HOMEPAGE="https://github.com/juliangruber/brace-expansion"
SRC_URI="https://github.com/juliangruber/brace-expansion/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

#RESTRICT="!test? ( test )"
#DEPEND="test? (
#	dev-nodejs/at-c4312-matcha
#	dev-nodejs/test
#)"

RDEPEND="dev-nodejs/balanced-match"

RESTRICT="test"

src_install() {
	insinto "${NODEJS_SITELIB}${PN}"
	doins package.json
	doins index.js
}
