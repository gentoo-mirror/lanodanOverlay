# Copyright 2023 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit nodejs

DESCRIPTION="Match balanced character pairs, like { and }"
HOMEPAGE="https://github.com/juliangruber/balanced-match"
SRC_URI="https://github.com/juliangruber/balanced-match/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RESTRICT="!test? ( test )"

src_prepare() {
	default

	# standard: linter; no need in a distro package
	sed -i 's;"test": "standard --fix && node--test;"test": "node --test;' package.json || die

	# 'test' is just a port of 'node:test' from NodeJS 18+
	sed -i "s;import test from 'test';import test from 'node:test';" test/test.js || die
}
