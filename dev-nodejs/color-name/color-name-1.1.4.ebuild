# Copyright 2022 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit nodejs

DESCRIPTION="JSON with CSS color names and its values"
HOMEPAGE="https://github.com/colorjs/color-name"
SRC_URI="https://github.com/colorjs/color-name/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"

src_test() {
	node test.js || die
}

src_install() {
	insinto "${NODEJS_SITELIB}${PN}"
	doins package.json

	cat package.json | jq -r .files[] | while read pkg
	do
		insinto "${NODEJS_SITELIB}${PN}/$(dirname "$pkg")"
		doins -r "$pkg"
	done
}
