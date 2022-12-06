# Copyright 2022 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit nodejs

DESCRIPTION="dead-simple optimistic async helper in javascript"
HOMEPAGE="https://github.com/andrewrk/node-pend"
SRC_URI="https://github.com/andrewrk/node-pend/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/node-pend-${PV}"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

src_install() {
	insinto "${NODEJS_SITELIB}${PN}"
	doins package.json
	doins index.js
	dodoc README.md
}
