# Copyright 2022 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit nodejs

DESCRIPTION="cache object that deletes the least-recently-used items"
HOMEPAGE="https://github.com/isaacs/node-lru-cache"
SRC_URI="https://github.com/isaacs/node-lru-cache/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/node-${P}"
LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"

#IUSE="test"
#RESTRICT="!test? ( test )"
#DEPEND="test? ( dev-nodejs/tap )"

RESTRICT="test"

src_install() {
	insinto "${NODEJS_SITELIB}${PN}"
	doins package.json

	cat package.json | jq -r .files[] | while read pkg
	do
		doins -r "$pkg"
	done
}
