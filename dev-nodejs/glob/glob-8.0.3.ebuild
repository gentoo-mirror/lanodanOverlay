# Copyright 2022 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit nodejs

DESCRIPTION="little globber"
HOMEPAGE="https://github.com/isaacs/node-glob"
SRC_URI="https://github.com/isaacs/node-glob/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/node-${P}"
LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"

#IUSE="test"
#RESTRICT="!test? ( test )"
#DEPEND="test? (
#	dev-nodejs/memfs
#	dev-nodejs/mkdirp
#	dev-nodejs/rimraf
#	dev-nodejs/tap
#	dev-nodejs/tick
#)"

RDEPEND="
	dev-nodejs/fs-realpath
	dev-nodejs/inflight
	dev-nodejs/inherits
	dev-nodejs/minimatch
	dev-nodejs/once
"

RESTRICT="test"

src_install() {
	insinto "${NODEJS_SITELIB}${PN}"
	doins package.json

	cat package.json | jq -r .files[] | while read pkg
	do
		doins -r "$pkg"
	done
}
