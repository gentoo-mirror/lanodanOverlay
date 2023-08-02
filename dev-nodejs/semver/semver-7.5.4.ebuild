# Copyright 2022 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit nodejs

DESCRIPTION="semantic version parser used by npm"
HOMEPAGE="https://github.com/npm/node-semver"
SRC_URI="https://github.com/npm/node-semver/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/node-${P}"
LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

#RESTRICT="!test? ( test )"
#DEPEND="test? ( dev-nodejs/tap )"
RDEPEND="dev-nodejs/lru-cache"

RESTRICT="test"

src_install() {
	insinto "${NODEJS_SITELIB}${PN}"
	doins package.json

	cat package.json | jq -r .files[] | while read pkg
	do
		doins -r "$pkg"
	done

	fperms 755 "${NODEJS_SITELIB}${PN}/bin/semver.js"
	dosym "${NODEJS_SITELIB}${PN}/bin/semver.js" "${EPREFIX}/usr/bin/semver"
}
