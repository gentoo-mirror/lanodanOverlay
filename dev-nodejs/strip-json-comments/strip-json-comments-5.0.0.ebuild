# Copyright 2023 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit nodejs

DESCRIPTION="Strip comments from JSON"
HOMEPAGE="https://github.com/sindresorhus/strip-json-comments"
SRC_URI="https://github.com/sindresorhus/strip-json-comments/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

# test dependencies: ava, tsd, xo
RESTRICT="test"

DOCS=( readme.md )

src_install() {
	einstalldocs
	insinto "${NODEJS_SITELIB}${PN}"
	doins package.json
	doins index.js
}
