# Copyright 2022-2023 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit nodejs

DESCRIPTION="deep deletion module for node (like 'rm -rf')"
HOMEPAGE="https://github.com/isaacs/rimraf"
SRC_URI="https://github.com/isaacs/rimraf/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

#RESTRICT="!test? ( test )"
#DEPEND="test? ( dev-nodejs/tap dev-nodejs/mkdirp )"

RDEPEND=">=dev-nodejs/glob-10.2.5"

RESTRICT="test"

src_prepare() {
	default

	sed -i -e '/LICENSE/d' -e '/README.md/d' package.json || die
}

src_install() {
	insinto "${NODEJS_SITELIB}${PN}"
	doins package.json

	cat package.json | jq -r .files[] | while read pkg
	do
		doins -r "$pkg"
	done
}
