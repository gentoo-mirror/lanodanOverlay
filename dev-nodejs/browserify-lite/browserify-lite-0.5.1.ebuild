# Copyright 2022 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit nodejs

DESCRIPTION="browserify, minus some of the advanced features and heavy dependencies"
HOMEPAGE="https://github.com/andrewrk/browserify-lite"
SRC_URI="https://github.com/andrewrk/browserify-lite/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=dev-nodejs/pend-1.2.0"
DEPEND="${RDEPEND}"

src_install() {
	insinto "${NODEJS_SITELIB}${PN}"
	doins package.json
	doins index.js
	doins cli.js
	dodoc README.md

	fperms 755 "${NODEJS_SITELIB}${PN}/cli.js"
	dosym "${NODEJS_SITELIB}${PN}/cli.js" "${EPREFIX}/usr/bin/${PN}"
}
