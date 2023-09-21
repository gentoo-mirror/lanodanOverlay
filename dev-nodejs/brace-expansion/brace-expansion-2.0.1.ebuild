# Copyright 2022-2023 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit nodejs

DESCRIPTION="Brace expansion, as known from sh/bash, in JavaScript"
HOMEPAGE="https://github.com/juliangruber/brace-expansion"
SRC_URI="https://github.com/juliangruber/brace-expansion/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RESTRICT="!test? ( test )"

RDEPEND="dev-nodejs/balanced-match"
DEPEND="
	${RDEPEND}
	test? ( dev-nodejs/tape-lite )
"

# Note: [PR60] switches to node:test, but doesn't cleanly applies on 2.0.1
# PR60: https://github.com/juliangruber/brace-expansion/pull/60

src_prepare() {
	default

	sed -i 's;tape test/\*.js;node --test;' package.json || die
	sed -i "s;require('tape');require('tape-lite');" test/*.js || die
	rm test/perf/bench.js || die
}
