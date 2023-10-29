# Copyright 2023 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit nodejs

DESCRIPTION="quote and parse shell commands"
HOMEPAGE="https://github.com/ljharb/shell-quote"
SRC_URI="https://github.com/ljharb/shell-quote/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RESTRICT="!test? ( test )"

DEPEND="test? ( dev-nodejs/tape-lite )"
BDEPEND="dev-util/esbuild"

src_prepare() {
	default

	#sed -i '/"tests-only": /s;nyc tape;node --test;' package.json || die
	sed -i "s;require('tape');require('tape-lite');;" test/*.js || die
}

src_test() {
	node --test test/*.js || die
}
