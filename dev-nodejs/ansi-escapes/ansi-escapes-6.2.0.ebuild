# Copyright 2022-2023 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit nodejs

DESCRIPTION="ANSI escape codes for manipulating the terminal"
HOMEPAGE="https://github.com/sindresorhus/ansi-escapes"
SRC_URI="https://github.com/sindresorhus/ansi-escapes/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

#IUSE="test"
#RESTRICT="!test? ( test )"
#DEPEND="test? (
#	dev-nodejs/ava
#	dev-nodejs/tsd
#	dev-nodejs/xo
#)"

# Note: type-fest dependency is just for TypeScript
#RDEPEND=""

RESTRICT="test"

DOCS=( example.js readme.md )

src_install() {
	einstalldocs

	insinto "${NODEJS_SITELIB}${PN}"
	doins package.json

	cat package.json | jq -r .files[] | while read pkg
	do
		doins -r "$pkg"
	done
}
